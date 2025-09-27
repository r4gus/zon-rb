# frozen_string_literal: true

require_relative "zon/version"
require_relative "zon/lexer"
require_relative "zon/parser"

module Zon
  class Error < StandardError; end

  def self.parse(input)
    data = nil

    if input.is_a? String
      data = input
    elsif input.is_a? IO
      data = input.read
    else
      raise ArgumentError, "Input must be a String or a File/IO object"
    end

    tokens = Zon::Lexer.parse data
    parser = Zon::Parser.new tokens
    return parser.parse
  end
end

