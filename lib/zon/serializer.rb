module Zon
  module Serializer
    def self.serialize_object(obj, options = {}, level = 0)

      defaults = { :indent_level => 0, :ibase => 16 }
      options = defaults.merge(options)

      if obj.is_a? Integer
        s = ""
        case options[:ibase]
        when 16
          s += "0x"
        when 8
          s += "0o"
        when 2
          s += "0b"
        end

        s += obj.to_s(options[:ibase])
        s
      elsif obj.is_a? Float
        String(obj)
      elsif obj.is_a? String
        "\"" + obj + "\""
      elsif obj.is_a? Array
        out = ""
        l = obj.length

        out += ".{"
        if options[:indent_level] > 0
          out += "\n"
        end
        
        obj.each.with_index do |elem, idx|
          if options[:indent_level] > 0
            out += " " * (options[:indent_level] * (level + 1))
          else
            out += " "
          end

          out += self.serialize_object(elem, options, level + 1) 

          if options[:indent_level] > 0
            out += ",\n" 
          else
            out += "," if idx < l - 1 # l is at least 1 otherwise this loop is not entered
            out += " " if idx == l - 1 # last elem
          end
        end
        
        if options[:indent_level] > 0
            out += " " * (options[:indent_level] * level)
        end
        out += "}"
        out
      elsif obj.is_a? Hash
        out = ""
        l = obj.length

        out += ".{"
        if options[:indent_level] > 0
          out += "\n"
        end

        obj.each.with_index do |kv, idx|
          key = kv[0]
          value = kv[1]

          raise "Key #{key} must be a Symbol" if not key.is_a? Symbol

          if options[:indent_level] > 0
            out += " " * (options[:indent_level] * (level + 1))
          else
            out += " "
          end

          out += "." + String(key)
          out += " = "
          out += self.serialize_object(value, options, level + 1) 
          if options[:indent_level] > 0
            out += ",\n" 
          else
            out += "," if idx < l - 1 # l is at least 1 otherwise this loop is not entered
            out += " " if idx == l - 1 # last elem
          end
        end

        if options[:indent_level] > 0
            out += " " * (options[:indent_level] * level)
        end
        out += "}"
        out
      elsif obj.is_a? TrueClass
        "true"
      elsif obj.is_a? FalseClass
        "false"
      elsif obj.is_a? Symbol
        "." + String(obj)
      else
        raise ArgumentError, "Unable to serialize '#{obj}' of Class '#{obj.class}' to ZON"
      end 
    end
  end
end
