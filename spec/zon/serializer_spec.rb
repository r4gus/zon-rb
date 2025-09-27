# frozen_string_literal: true

RSpec.describe Zon::Serializer do

    it "serializes true correctly" do
      v = Zon::Serializer::serialize_object(true)
      expect(v).to eq("true")
    end

    it "serializes false correctly" do
      v = Zon::Serializer::serialize_object(false)
      expect(v).to eq("false")
    end

    it "serializes the String 'hello world' correctly" do
      v = Zon::Serializer::serialize_object("hello world")
      expect(v).to eq("\"hello world\"")
    end

    it "serializes the Numeric 1234 correctly" do
      v = Zon::Serializer::serialize_object(1234, {:ibase => 10})
      expect(v).to eq("1234")
    end

    it "serializes the Numeric 1234.5678 correctly" do
      v = Zon::Serializer::serialize_object(1234.5678)
      expect(v).to eq("1234.5678")
    end

    it "serializes the Array ['hello', 'world'] correctly" do
      v = Zon::Serializer::serialize_object(["hello", "world"])
      expect(v).to eq(".{ \"hello\", \"world\" }")
    end

    it "serializes the Hash { :name => :passkeez } correctly" do
      v = Zon::Serializer::serialize_object({:name => :passkeez})
      expect(v).to eq(".{ .name = .passkeez }")
    end

    it "serializes the Hash { :name => :passkeez } with indent_level = 4 correctly" do
      v = Zon::Serializer::serialize_object({:name => :passkeez}, { :indent_level => 4 })
      e = <<~ZON
      .{
          .name = .passkeez,
      }
      ZON
      expect(v).to eq(e[..-2])
    end

    it "serializes the Array ['hello', 'world'] with indent_level = 4 correctly" do
      v = Zon::Serializer::serialize_object(["hello", "world"], {:indent_level => 4})
      e = <<~ZON
      .{
          "hello",
          "world",
      }
      ZON
      expect(v).to eq(e[..-2])
    end

    it "serializes an Zig package manifest correctly" do
      e = <<~MANIFEST
      .{
          .name = .passkeez,
          .version = "0.5.3",
          .fingerprint = 0xdd1692d15d21a6f6,
          .dependencies = .{
              .keylib = .{
                  .url = "https://github.com/Zig-Sec/keylib/archive/refs/tags/0.6.1.tar.gz",
                  .hash = "keylib-0.6.1-mbYjk9-WCQBOqB9oq2ZqWQFeWI2HwuBEuPgL-wkJDHTg",
              },
              .uuid = .{
                  .url = "https://github.com/r4gus/uuid-zig/archive/refs/tags/0.3.1.tar.gz",
                  .hash = "uuid-0.3.0-oOieIYF1AAA_BtE7FvVqqTn5uEYTvvz7ycuVnalCOf8C",
              },
              .ccdb = .{
                  .url = "https://github.com/r4gus/ccdb/archive/refs/tags/0.3.1.tar.gz",
                  .hash = "ccdb-0.3.2-mrOGYn4KDgC0cJl4CKpKaJB95wwIlHegHLV7NSbMYXu0",
              },
              .kdbx = .{
                  .url = "https://github.com/Zig-Sec/kdbx/archive/refs/tags/0.1.4.tar.gz",
                  .hash = "kdbx-0.1.4-eJXZBMa7CgAIw7kG02QYyv1sFcePsjfoGH9-Ptl3wrTC",
              },
          },
          .paths = .{
              "build.zig",
              "build.zig.zon",
              "linux",
              "README.md",
              "script",
              "src",
              "static",
          },
      }
      MANIFEST

      manifest = {
        :name => :passkeez, 
        :version => "0.5.3", 
        :fingerprint => 0xdd1692d15d21a6f6,
        :dependencies => {
          :keylib => {
            :url => "https://github.com/Zig-Sec/keylib/archive/refs/tags/0.6.1.tar.gz",
            :hash => "keylib-0.6.1-mbYjk9-WCQBOqB9oq2ZqWQFeWI2HwuBEuPgL-wkJDHTg",
          },
          :uuid => {
            :url => "https://github.com/r4gus/uuid-zig/archive/refs/tags/0.3.1.tar.gz",
            :hash => "uuid-0.3.0-oOieIYF1AAA_BtE7FvVqqTn5uEYTvvz7ycuVnalCOf8C",
          },
          :ccdb => {
            :url => "https://github.com/r4gus/ccdb/archive/refs/tags/0.3.1.tar.gz",
            :hash => "ccdb-0.3.2-mrOGYn4KDgC0cJl4CKpKaJB95wwIlHegHLV7NSbMYXu0",
          },
          :kdbx => {
            :url => "https://github.com/Zig-Sec/kdbx/archive/refs/tags/0.1.4.tar.gz",
            :hash => "kdbx-0.1.4-eJXZBMa7CgAIw7kG02QYyv1sFcePsjfoGH9-Ptl3wrTC",
          },
        },
        :paths => [
          "build.zig",
          "build.zig.zon",
          "linux",
          "README.md",
          "script",
          "src",
          "static",
        ],
      }

      v = Zon::Serializer::serialize_object(manifest, {:indent_level => 4})
      expect(v).to eq(e[..-2])
    end

end
