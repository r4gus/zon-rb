require "digest"
require "find"
require "base64"

module Zon
  ##
  # Produces a package hash of the format: $name-$semver-$hashplus
  #
  # Along with 200 bits of a SHA-256, a package hash includes:
  # - package name
  # - package version
  # - id component of the package fingerprint
  # - total unpacked size on disk
  #
  # The following steps are taken to calculate the hash:
  # 1. Read the list of included paths from the manifest, i.e. files that are part of the package.
  # 2. Resolve the paths:
  #     - for directories: include all files that are within the directory or a child dir.
  #     - for files: include the file
  #     - for symlinks: TODO
  # 3. Sort the paths by:
  #     1. Lexographical order
  #     2. by length
  # 4. For every included file:
  #     - Calculate a SHA-256 over: RELATIVE_PATH_FROM_PKG_ROOT || 0x0000 || DATA
  #     - Record the file size in bytes
  #     - TODO: the 0x0000 will probably change in the future
  # 5. Calculate a SHA-256 sum over all calculated file hashes
  #     - respecting the previously mentioned sorting rules.
  # 6. Sum up the sizes of all files into a u32 (sizes that don't fit into a 32-bit unsingned integer will be saturated with the value 2**32 - 1)
  # 7. Produce the package hash
  class Hasher
    attr_reader :paths, :total_size, :digest

    SUPPORTED_ZIG_VERSIONS = ["0.14.0", "0.14.1", "0.15.1", "0.15.2"]

    def initialize(package_path, manifest_name: "build.zig.zon")
      # Make sure we have a valid path to work with
      @package_path = package_path
      raise ArgumentError, "not a directory '#{@package_path}'" if not Dir.exist? @package_path

      manifest_path = File.join(@package_path, manifest_name)
      raise ArgumentError, "no manifest '#{manifest_name}' in '#{@package_path}'" if not File.exist? manifest_path

      @manifest = Zon.parse(File.open(manifest_path))
      raise ArgumentError, "no 'paths' field in ZON manifest '#{manifest_path}'" if not @manifest.key? :paths
      raise ArgumentError, "no 'name' field in ZON manifest '#{manifest_path}'" if not @manifest.key? :name
      raise ArgumentError, "no 'version' field in ZON manifest '#{manifest_path}'" if not @manifest.key? :version
      raise ArgumentError, "no 'fingerprint' field in ZON manifest '#{manifest_path}'" if not @manifest.key? :fingerprint
      
      @paths = []
      @results = {}
      @total_size = 0
      @digest = nil

      @manifest[:paths].each do |path|
        full_path = File.join(@package_path, path)

        if File.directory? full_path
          f = Find.find(full_path)
          f.each do |p|
            next if File.directory? p
            
            pstr = p.delete_prefix(@package_path)[1..]
            @paths.append(pstr) if not @paths.include? pstr
          end
        elsif File.file? full_path or File.symlink? full_path
          pstr = full_path.delete_prefix(@package_path)[1..]
          @paths.append(pstr) if not @paths.include? pstr
        end
      end

      @paths = @paths.sort_by { |str| [str, -str.length] }
    end

    def name
      String(@manifest[:name])
    end

    def version
      @manifest[:version]
    end

    def hash
      @total_size = 0
      @digest = nil
      
      # Hash all files individually  
      @paths.each do |str|
        @results[str] = Zon::Hasher::hash_file(@package_path, str)
      end 

      sha2 = Digest::SHA2.new

      @paths.each do |str|
        res = @results[str]

        @total_size += res[:size]
        sha2.update [res[:digest]].pack('H*')
      end

      @digest = sha2.hexdigest
    end
    
    ##
    # Get the ID part of the fingerprint
    def get_id
      @manifest[:fingerprint] & 0xffffffff
    end
    
    ##
    # Get the calculated, total size of the unpacked package.
    def get_saturated_size
      max_uint32 = 2**32 - 1

      if @total_size > max_uint32
        max_uint32
      else
        @total_size
      end
    end

    def result
      Zon::Hasher::make_hash(@digest, name, version, get_id, get_saturated_size)
    end
    
    ##
    # Produces $name-$semver-$hashplus
    #
    # - name is the name field from a build.zig.zon manifest. It is expected
    # to be at most 32 bytes long and a valid Zig identifier.
    # - semver is the version field from a build.zig.zon manifest. It is expected
    # to be at most 32 bytes long.
    # - hashplus is a base64 (urlsafe and nopad) encoded, 33-byte string:
    #     - Pacakge ID (4) || Decompressed Size (4) || Digest0, Digest1, ..., Digest24
    def self.make_hash(digest, name, semver, id, size)
      raise ArgumentError, "name '#{name}' is expected to be at most 32 bytes long but it is #{name.bytesize} bytes" if name.bytesize > 32
      raise ArgumentError, "semver '#{semver}' is expected to be at most 32 bytes long but it is #{semver.bytesize} bytes" if semver.bytesize > 32

      hash_plus = [id].pack("V")
      hash_plus += [size].pack("V")
      hash_plus += [digest].pack('H*')[0..24]

      "#{name}-#{semver}-#{Base64.urlsafe_encode64(hash_plus, padding: false)}"
    end

    def self.hash_file(package_path, path)
      sha2 = Digest::SHA2.new    
      sha2.update path

      full_path = File.join(package_path, path)

      if File.file? full_path
        f = File.open full_path
        data = f.read
        file_size = data.bytesize
        
        # Hard-coded false executable bit: https://github.com/ziglang/zig/issues/17463
        sha2.update "\x00\x00"
        sha2.update data
      elsif File.symlink? full_path
        link_name = File.readlink full_path
        sha2.update link_name
      end

      # TODO: symlink

      {
        digest: sha2.hexdigest,
        size: file_size,
      }
    end
  end
end
