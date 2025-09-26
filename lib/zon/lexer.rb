module Zon
  module Lexer
    class TokenType
      LITERAL = 0
      STRING = 1
      NUMBER = 2
      BOOLEAN = 3
      LBRACE = 4
      RBRACE = 5
      EQUALS = 6
      COMMA = 7
    end

    class Token
      attr_accessor :type
      attr_accessor :value

      def initialize(type, value)
        @type = type
        @value = value
      end

      def ==(other)
        self.type == other.type and self.value == other.value
      end
    end

    def self.read(input)
      curr = ""
      in_comment = false
      in_string = false

      Enumerator.new do |y|
        input.each_char.with_index do |char, idx|
          # Handle comments
          if not in_string and not in_comment and char == "/" and input[idx + 1] == "/"
            if curr.length > 0
              y << curr
              curr = ""
            end 
            in_comment = true
            next
          elsif in_comment and char.match?(/(\r\n|\n|\r)/)
            # there are only line comments, i.e. every
            # line needs to be commented separately.
            in_comment = false
            next
          elsif in_comment
            next
          end
          
          if not in_string and char.match?(/\s/) # is whitespace
            if curr.length > 0
              y << curr
              curr = ""
            end 
            next
          end

          if not in_string and char == "{"
            if curr[-1] == "."
              y << ".{"
              curr = ""
            else
              raise "Invalid character #{curr[-1]} preceding '{' at index #{idx}" 
            end
          elsif not in_string and ["}", "=", ","].include?(char)
            y << curr if curr.length > 0
            y << char
            curr = ""
          else
            in_string = not in_string if char == "\""
            curr += char
          end
        end
      end
    end

    def self.parse(input)
      Enumerator.new do |y|
        self.read(input).with_index do |token_str, idx|
          if token_str == ".{"
            y << Token.new(TokenType::LBRACE, token_str)
          elsif token_str == "}"
            y << Token.new(TokenType::RBRACE, token_str)
          elsif token_str == "="
            y << Token.new(TokenType::EQUALS, token_str)
          elsif token_str == ","
            y << Token.new(TokenType::COMMA, token_str)
          elsif token_str[0] == '"'
            if token_str.length <= 1 or not token_str[-1] == '"'
              raise "Token string at index #{idx} not terminated"
            end
            y << Token.new(TokenType::STRING, token_str)
          elsif ["true", "false"].include?(token_str)
            y << Token.new(TokenType::BOOLEAN, token_str)
          elsif self.is_number? token_str
            y << Token.new(TokenType::NUMBER, token_str)
          elsif self.is_literal? token_str
            y << Token.new(TokenType::LITERAL, token_str)
          else
            raise "Unknown token '#{token_str}' at index #{idx}"
          end
        end
      end
    end

    def self.is_literal?(token_str)
      literal_regex = /\.[a-zA-Z][a-zA-Z_]*/
      !!(token_str =~ literal_regex)
    end

    def self.is_number?(token_str)
      number_regex = /\A
        [+-]?                  # optional sign
        (
          0[xX][0-9a-fA-F]+    # hex
          |
          0[bB][01]+           # binary
          |
          0[oO]?[0-7]+         # octal (0o77 or classic 077)
          |
          \d+                  # decimal
        )
      \z/x
      !!(token_str =~ number_regex)
    end
  end
end
