require_relative "lexer"

Lexer = Zon::Lexer

module Zon

  class Parser
    STRUCT = 0 
    ARRAY = 1

    def initialize(tokens)
      @tokens = tokens
      @curr = nil
    end

    def next
      begin
        @curr = @tokens.next
      rescue
        @curr = nil
      end
    end

    def parse
      if self.next_token? Lexer::TokenType::LBRACE
        self.next

        if self.next_token? Lexer::TokenType::RBRACE # '.{ }'
          self.next
          return {} # this could either be a array or a struct... we don't know
        end

        v = self.parse

        if v.is_a? Symbol and self.next_token? Lexer::TokenType::EQUALS
          # This is a Zon struct, i.e. translate it to a Ruby hash
          k = v
          self.next_equals # skip equals
          v = self.parse

          h = {k => v}

          loop do # fetch remaining key value pairs
            self.next if self.next_token? Lexer::TokenType::COMMA
            if self.next_token? Lexer::TokenType::RBRACE
              self.next
              break
            end

            k = self.next_key
            self.next_equals
            v = self.parse
            h[k] = v
          end

          return h
        else
          # Must be an array
          
          a = [v]

          loop do # fetch remaining values
            self.next if self.next_token? Lexer::TokenType::COMMA
            if self.next_token? Lexer::TokenType::RBRACE
              self.next
              break
            end
            
            a.append self.parse
          end

          return a
        end
      else
        return self.next_value
      end
    end

    def next_token?(type)
      self.peek_token.type == type 
    end

    def peek_token
      begin
        @tokens.peek
      rescue
        nil
      end
    end

    def next_key
      self.next

      if @curr and @curr.type == Lexer::TokenType::LITERAL
        @curr.value[1..].to_sym # create sym from string without the '.'
      elsif
        raise "Expected literal token but got '#{@curr.value}'"
      end
    end

    def next_value
      self.next

      raise "No token for value" if not @curr

      value = nil

      if @curr.type == Lexer::TokenType::LITERAL
        value = @curr.value[1..].to_sym
      elsif @curr.type == Lexer::TokenType::STRING
        value = @curr.value[1..-2]
      elsif @curr.type == Lexer::TokenType::NUMBER
        begin
          if @curr.value.include? "."
            value = Float(@curr.value)
          else
            value = Integer(@curr.value)
          end
        rescue
          raise "Unable to parse number from value '#{@curr.value}'"
        end
      elsif @curr.type == Lexer::TokenType::BOOLEAN
        if @curr.value == "true"
          value = true
        else
          value = false
        end
      end

      raise "Unable to parse value from '#{@curr.value}'" if not value

      value
    end

    def next_equals
      self.next

      if not @curr or not @curr.type == Lexer::TokenType::EQUALS
        raise "Expected '=' token but got '#{@curr.value}'"
      end
    end
  end

end
