module Hattr
  module HashBuilder
    module_function

    ARRAY_TYPE_DEFAULT = Array[String]
    HASH_TYPE_DEFAULT  = Hash[Symbol => String]

    def generate(spec, raw)
      opts = spec.delete(ClassMethods::OPTIONS_STORAGE_KEY)
      attributes = spec.keys

      raw = raw.symbolize_keys unless opts[:string_keys]
      raw.each { |k, v| raw[k] = typecast(v, spec.fetch(k.to_sym, ClassMethods::ATTR_DEFAULTS)[:type]) }
    end

    def typecast(value, type)
      case
      when type.class == Hash then hash_typecast(value, type)
      when type.class == Array then array_typecast(value, type)
      else primitive_typecast(value, type)
      end
    end

    def primitive_typecast(value, type)
      case
      when type == Integer, type == Fixnum then value.to_i
      when type == Float then value.to_f
      when type == Symbol then value.to_sym
      when type == Array then array_typecast(value, ARRAY_TYPE_DEFAULT)
      when type == Hash then hash_typecast(value, HASH_TYPE_DEFAULT)
      else value
      end
    end

    def hash_typecast(value, model)
      key_type, val_type = model.flatten
      hash = string_to_hash(value)

      hash = key_type == Symbol ? hash.symbolize_keys : hash
      hash.each { |k, v| hash[k] = typecast(v, val_type) }
    end

    def array_typecast(value, model)
      val_type = model.first
      array = string_to_array(value)

      array.map { |elem| typecast(elem, val_type) }
    end

    def string_to_hash(str)
      Hash[str.tr('{}:" ', '').split(',').map { |pair| pair.split('=>') }]
    end

    def string_to_array(str)
      str.tr('[]:" ', '').split(',')
    end
  end
end
