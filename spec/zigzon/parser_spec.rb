# frozen_string_literal: true

RSpec.describe Zon::Parser do
    Parser = described_class
    Lexer = Zon::Lexer

    context "parse simple struct" do 

      before do
        @dict = <<~ZON
        .{
          .name = .passkeez,
          .version = "0.5.3",
          .fingerprint = 0xdd1692d15d21a6f6,
        }
        ZON
      end

      it "parses a ZON string into a Ruby object" do
        expected = {
          :name => :passkeez, 
          :version => "0.5.3", 
          :fingerprint => 0xdd1692d15d21a6f6
        }

        tokens = Lexer.parse @dict
        parser = Parser.new tokens

        obj = parser.parse

        expect(obj).to eq(expected)
      end

    end

    context "valid build.zig.zon for packages supporting Zig 0.15.1" do
      before do
        @dict = <<~ZON
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
        ZON
      end

      it "parses a ZON string into a Ruby object" do
        expected = {
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

        tokens = Lexer.parse @dict
        parser = Parser.new tokens

        obj = parser.parse

        expect(obj).to eq(expected)
      end

    end

end
