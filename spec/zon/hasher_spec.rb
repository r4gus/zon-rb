# frozen_string_literal: true

require "zlib"
require "minitar"

RSpec.describe Zon::Hasher do
  def unpack_archive(to, from)
    Zlib::GzipReader.open(from) do |gz|
      Minitar.unpack(gz, to)
    end
  end
  
  it "serializes the single components of a hash to a valid hash of the format nnnn-vvvv-hhh...h" do
    digest = "c7f571b7b4e76f3cdb877a7fddf977879dd386fa73579af79d1edb8f3ad9bd9f"
    h = Zon::Hasher.make_hash(digest, "nasm", "2.16.1-3", 0xcafebabe, 10 * 1024 * 1024)
    expect(h).to eq("nasm-2.16.1-3-vrr-ygAAoADH9XG3tOdvPNuHen_d-XeHndOG-nNXmved")
  end

  it "serializes individula files for uuid-0.4.0 correctly" do
    archive = File.join(__dir__, "fixtures", "uuid-zig-0.4.0.tar.gz")
    wdir = File.join(__dir__, "fixtures", "uuid-zig-0.4.0")
    pdir = File.join(__dir__, "fixtures", "uuid-zig-0.4.0", "uuid-zig-0.4.0")
    unpack_archive(wdir, archive)

    begin
      expect(Zon::Hasher.hash_file(pdir, ".github/ISSUE_TEMPLATE/bug_report.md")[:digest]).to eq("5a6e501727180d4f56b99f2ca93b8430a6cba0453eeb0e906fbdea5a6616a9db")
      expect(Zon::Hasher.hash_file(pdir, ".github/workflows/main.yml")[:digest]).to eq("21613aa7a4f2a4ac259bd662dcf35f6519061dbf3cfe611f084af881322387ab")
      expect(Zon::Hasher.hash_file(pdir, ".gitignore")[:digest]).to eq("57ca9a9c4274f79b90a0cc231c5d35637929f99e04071d4a5e0112ebbab3d7d4")
      expect(Zon::Hasher.hash_file(pdir, "README.md")[:digest]).to eq("ba28309ee2fe3eaaa31908f14f53ffad1ccfb6e3810fa175242b632141aa812c")
      expect(Zon::Hasher.hash_file(pdir, "bench/main.zig")[:digest]).to eq("f814ff873efa050863ba2a067f54983d660e3dde13767c849a8bae36fc1834fd")
      expect(Zon::Hasher.hash_file(pdir, "build.zig")[:digest]).to eq("2f201a72bc97354c85893705d2b62e023f1d15d288de4643f14f4a98873c80ce")
      expect(Zon::Hasher.hash_file(pdir, "build.zig.zon")[:digest]).to eq("d845cd0575d9d9ea85a947f8e8bfa083002ddf68fbde6be9af21b13dd8fc2fe9")
      expect(Zon::Hasher.hash_file(pdir, "examples/cexample.c")[:digest]).to eq("c077da1041015ae65d2ee5dbaf16f575eb878b3475da5b80d674a31f3ad8e638")
      expect(Zon::Hasher.hash_file(pdir, "examples/uuid_v4.zig")[:digest]).to eq("0ea2698d9eac79cb334f882b7134f688a9574e962a265141fe96b35368a92023")
      expect(Zon::Hasher.hash_file(pdir, "examples/uuid_v7.zig")[:digest]).to eq("a3975cdd4fbef6d94546e7c7ef96dec13b1a863f32d35540323ddfa5194aa918")
      expect(Zon::Hasher.hash_file(pdir, "license")[:digest]).to eq("e70d550964a0e7cca9bdc4a5b0f94fd7cd9f7bad74d7f20cdbf00dd1eb4fa9c3")
      expect(Zon::Hasher.hash_file(pdir, "src/core.zig")[:digest]).to eq("93ec0bce3b02ce74cc99cdd29bb01b0e68a1edd48719f92b38a7d982b493d3fa")
      expect(Zon::Hasher.hash_file(pdir, "src/main.zig")[:digest]).to eq("bd3d5d07291d7ecf51f53e3234ddc3710a81a1451323cebd5c0bc09dc92a6dfd")
      expect(Zon::Hasher.hash_file(pdir, "src/name.zig")[:digest]).to eq("40b2b0986e4fe4d3c917c7ba7af0f894d5d60b4169c87e6da810c26fcba7eb80")
      expect(Zon::Hasher.hash_file(pdir, "src/root.zig")[:digest]).to eq("865d93a0d3de573bb11b5239054e9fe167790f740f53a1ca0f60392cb4c6860d")
      expect(Zon::Hasher.hash_file(pdir, "src/urn.zig")[:digest]).to eq("3a307806815920b1abd3d1d1d67cd01d4cc67f7532dec70e42152a931db18ec8")
      expect(Zon::Hasher.hash_file(pdir, "src/uuid.h")[:digest]).to eq("820092e99bf5a429b4b5ca9be7f8264bc154372b3a818b44606c982bcd335fd1")
      expect(Zon::Hasher.hash_file(pdir, "src/v4.zig")[:digest]).to eq("914c71d2e19ea27dcf9243e8ab3a7964802e30f79a893eb6fb3c8aac4550c964")
      expect(Zon::Hasher.hash_file(pdir, "src/v7.zig")[:digest]).to eq("2fea2323817b32e71098b9d0656a8221a643273ade8376d1c0998fc7a25ad12c")
    ensure
      FileUtils.rm_rf wdir if Dir.exist? wdir 
    end
  end

  it "sorts the individual files for uuid-0.4.0 in the right order" do
    archive = File.join(__dir__, "fixtures", "uuid-zig-0.4.0.tar.gz")
    wdir = File.join(__dir__, "fixtures", "uuid-zig-0.4.0")
    pdir = File.join(__dir__, "fixtures", "uuid-zig-0.4.0", "uuid-zig-0.4.0")
    unpack_archive(wdir, archive)

    expected = [
      ".github/ISSUE_TEMPLATE/bug_report.md",
      ".github/workflows/main.yml",
      ".gitignore",
      "README.md",
      "bench/main.zig",
      "build.zig",
      "build.zig.zon",
      "examples/cexample.c",
      "examples/uuid_v4.zig",
      "examples/uuid_v7.zig",
      "license",
      "src/core.zig",
      "src/main.zig",
      "src/name.zig",
      "src/root.zig",
      "src/urn.zig",
      "src/uuid.h",
      "src/v4.zig",
      "src/v7.zig",
    ]

    begin
      hasher = Zon::Hasher.new pdir

      expect(hasher.paths).to eq(expected)
    ensure
      FileUtils.rm_rf wdir if Dir.exist? wdir 
    end
  end

  it "calculates the correct hash: uuid-0.4.0-oOieIR2AAAChAUVBY4ABjYI1XN0EbVALmiN0JIlggC3i" do
    archive = File.join(__dir__, "fixtures", "uuid-zig-0.4.0.tar.gz")
    wdir = File.join(__dir__, "fixtures", "uuid-zig-0.4.0")
    pdir = File.join(__dir__, "fixtures", "uuid-zig-0.4.0", "uuid-zig-0.4.0")
    unpack_archive(wdir, archive)
      
    begin
      hasher = Zon::Hasher.new pdir
      hasher.hash
      result = hasher.result

      expect(result).to eq("uuid-0.4.0-oOieIR2AAAChAUVBY4ABjYI1XN0EbVALmiN0JIlggC3i")
    ensure
      FileUtils.rm_rf wdir if Dir.exist? wdir 
    end
  end
end
