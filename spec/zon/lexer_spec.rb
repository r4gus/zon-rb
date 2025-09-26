# frozen_string_literal: true

RSpec.describe Zon::Lexer do
    Lexer = described_class

    context "valid simple struct" do 

      before do
        @dict = <<~ZON
        .{
          .name = .passkeez,
          .version = "0.5.3",
          .fingerprint = 0xdd1692d15d21a6f6,
        }
        ZON
      end

      it "reads a ZON string into substrings" do
        strings = Lexer.read @dict

        expect(strings.next).to eq(".{")
        expect(strings.next).to eq(".name")
        expect(strings.next).to eq("=")
        expect(strings.next).to eq(".passkeez")
        expect(strings.next).to eq(",")
        expect(strings.next).to eq(".version")
        expect(strings.next).to eq("=")
        expect(strings.next).to eq("\"0.5.3\"")
        expect(strings.next).to eq(",")
        expect(strings.next).to eq(".fingerprint")
        expect(strings.next).to eq("=")
        expect(strings.next).to eq("0xdd1692d15d21a6f6")
        expect(strings.next).to eq(",")
        expect(strings.next).to eq("}")
      end

      it "parses a ZON string into tokens" do
        tokens = Lexer.parse @dict
        
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LBRACE, ".{"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".name"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".passkeez"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".version"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"0.5.3\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".fingerprint"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::NUMBER, "0xdd1692d15d21a6f6"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::RBRACE, "}"))
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

      it "parses the ZON string into tokens" do
        tokens = Lexer.parse @dict
        
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LBRACE, ".{"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".name"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".passkeez"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".version"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"0.5.3\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".fingerprint"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::NUMBER, "0xdd1692d15d21a6f6"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".dependencies"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LBRACE, ".{"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".keylib"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LBRACE, ".{"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".url"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"https://github.com/Zig-Sec/keylib/archive/refs/tags/0.6.1.tar.gz\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".hash"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"keylib-0.6.1-mbYjk9-WCQBOqB9oq2ZqWQFeWI2HwuBEuPgL-wkJDHTg\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::RBRACE, "}"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".uuid"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LBRACE, ".{"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".url"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"https://github.com/r4gus/uuid-zig/archive/refs/tags/0.3.1.tar.gz\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".hash"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"uuid-0.3.0-oOieIYF1AAA_BtE7FvVqqTn5uEYTvvz7ycuVnalCOf8C\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::RBRACE, "}"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".ccdb"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LBRACE, ".{"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".url"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"https://github.com/r4gus/ccdb/archive/refs/tags/0.3.1.tar.gz\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".hash"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"ccdb-0.3.2-mrOGYn4KDgC0cJl4CKpKaJB95wwIlHegHLV7NSbMYXu0\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::RBRACE, "}"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".kdbx"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LBRACE, ".{"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".url"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"https://github.com/Zig-Sec/kdbx/archive/refs/tags/0.1.4.tar.gz\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".hash"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"kdbx-0.1.4-eJXZBMa7CgAIw7kG02QYyv1sFcePsjfoGH9-Ptl3wrTC\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::RBRACE, "}"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::RBRACE, "}"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LITERAL, ".paths"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::EQUALS, "="))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::LBRACE, ".{"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"build.zig\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"build.zig.zon\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"linux\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"README.md\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"script\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"src\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::STRING, "\"static\""))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::RBRACE, "}"))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::COMMA, ","))
        expect(tokens.next).to eq(Lexer::Token.new(Lexer::TokenType::RBRACE, "}"))
      end
    end
end
