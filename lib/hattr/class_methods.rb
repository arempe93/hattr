# frozen_string_literal: true
module Hattr
  module ClassMethods
    GROUP_OPTIONS = [:string_keys, :declared_only]
    ATTR_OPTIONS  = [:type]

    GROUP_DEFAULTS = { string_keys: false, declared_only: false }
    ATTR_DEFAULTS  = { type: String }

    OPTIONS_STORAGE_KEY = :_hattr_options

    ARRAY_DEFAULT = Array[String]
    HASH_DEFAULT  = Hash[Symbol => String]

    def hattr_group(field, opts = {})
      validate_options(opts, GROUP_OPTIONS)
      store_group(field, GROUP_DEFAULTS.merge(opts))
    end

    def hattr(field, attribute, opts = {})
      raise ArgumentError, "`#{OPTIONS_STORAGE_KEY}` is reserved" if attribute.to_sym == OPTIONS_STORAGE_KEY

      validate_options(opts, ATTR_OPTIONS)
      store_attribute(field, attribute, ATTR_DEFAULTS.merge(opts))
    end

    def build_group_hash(spec, value)
      HashBuilder.generate(spec, value)
    end

    private

    def validate_options(opts, valid_keys)
      opts.keys.each do |k|
        unless valid_keys.include?(k)
          raise ArgumentError, "invalid option `#{k}`. Valid options include: :#{valid_keys.join(', :')}"
        end
      end
    end

    def store_group(field, opts)
      hattr_groups[field.to_sym] = { OPTIONS_STORAGE_KEY => opts }
      create_reader_method(field)
    end

    def store_attribute(field, attribute, opts)
      store_group(field, GROUP_DEFAULTS) unless hattr_groups[field]
      hattr_groups[field][attribute.to_sym] = opts
    end

    def create_reader_method(field)
      class_eval do
        define_method field do
          self.class.build_group_hash(self.class.hattr_groups[field].dup, read_attribute(:field))
        end
      end
    end
  end
end
