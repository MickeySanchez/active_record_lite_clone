require_relative '03_searchable'
require 'active_support/inflector'

# Phase IVa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key,
    :options
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    self.class_name.downcase.underscore + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      :foreign_key => "#{name.to_s.downcase}_id".to_sym,
      :class_name => name.to_s.camelcase,
      :primary_key => :id
    }

    @options = defaults.merge(options)

    @foreign_key = @options[:foreign_key]
    @class_name = @options[:class_name]
    @primary_key = @options[:primary_key]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      :foreign_key => "#{self_class_name.to_s.downcase}_id".to_sym,
      :class_name => name.to_s.camelcase.singularize,
      :primary_key => :id
    }

    @options = defaults.merge(options)

    @foreign_key = @options[:foreign_key]
    @class_name = @options[:class_name]
    @primary_key = @options[:primary_key]
  end
end

module Associatable
  # Phase IVb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    self.assoc_options[name] = options

    define_method(name.to_s) do
      foreign_key_value = self.send(options.foreign_key) # works with self.id
      options
        .model_class
        .where({:id => foreign_key_value})
        .first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)

    define_method(name.to_s) do
      foreign_key_value = self.id

      options
        .model_class
        .where({options.foreign_key => self.id})
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
