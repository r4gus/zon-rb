# frozen_string_literal: true

require_relative "zon/version"
require_relative "zon/lexer"
require_relative "zon/parser"
require_relative "zon/serializer"
require_relative "zon/zig"
require_relative "zon/hasher"

##
# Zig Object Notation (ZON) de-/serializer.
module Zon
  class Error < StandardError; end
  
  ##
  # Parse ZON data, represented as String or IO/File, into
  # a Ruby object.
  #
  # An ArgumentError is raised if input is neither a String nor
  # a IO object.
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
    parser.parse
  end
  
  ##
  # Serialize a Ruby object into a ZON string.
  #
  # Available options:
  # - { :indent_level => <Integer> } - Define the indentation level for each block
  # - { :ibase => <Integer> } - Specify the base (binary: 2, octal: 8, decimal: 10, hex: 16)
  def self.serialize(obj, options = {})
    Zon::Serializer::serialize_object(obj, options)
  end
end

