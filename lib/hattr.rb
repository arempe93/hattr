# frozen_string_literal: true
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/hash/keys'

require 'hattr/version'

require 'hattr/class_methods'
require 'hattr/hash_builder'

module Hattr
  def self.extended(receiver)
    receiver.class_attribute :hattr_groups, instance_reader: false, instance_writer: false
    receiver.hattr_groups = {}

    receiver.extend ClassMethods
  end
end
