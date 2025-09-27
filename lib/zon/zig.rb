module Zon

  ##
  # Everything related specifically to the Zig programming language.
  module Zig
    
    ##
    # An abstraction of the Zig package manifest.
    #
    # Every Zig package should have a +build.zig.zon+ in
    # its package root, the manifest. Like a manifest in
    # Ruby, it is used to describe the package and specify
    # required dependencies.
    class Manifest
      def initialize(zon)
        raise "Missing '.name'" if not zon[:name]
        raise "Missing '.version'" if not zon[:version]
        raise "Missing '.fingerprint'" if not zon[:fingerprint]

        if zon[:dependencies]
          zon[:dependencies].each do |key, value|
            if value[:url]
              raise "Missing '.hash' for dependency '#{key}'" if not value[:hash]
            elsif not value[:path]
              raise "Expected either '.url' or '.path' for dependency '#{key}'" if not value[:hash]
            end 
          end
        end

        @zon = zon
      end
      
      ##
      # Get the '.name' field of the manifest.
      def name
        @zon[:name]
      end

      ##
      # Get the '.version' field of the manifest.
      def version
        @zon[:version]
      end

      ##
      # Get the '.fingerprint' field of the manifest.
      def fingerprint
        @zon[:fingerprint]
      end

      ##
      # Get the '.dependencies' field of the manifest.
      #
      # This will return nil if the '.dependencies' field does not exist.
      def dependencies
        @zon[:dependencies]
      end

      ##
      # Get the '.paths' field of the manifest.
      #
      # This will return nil if the '.paths' field does not exist.
      def paths
        @zon[:paths]
      end

      ##
      # Get the '.minimum_zig_version' field of the manifest.
      #
      # This will return nil if the '.minimum_zig_version' field does not exist.
      def minimum_zig_version
        @zon[:minimum_zig_version]
      end

    end

  end

end
