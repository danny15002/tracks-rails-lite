require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    # ...
    self.class_name.constantize
  end

  def table_name
    # ...
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    # ...
    self.class_name = "#{name.capitalize.to_s.singularize}"
    self.primary_key = :id
    self.foreign_key = :"#{name}_id"

    unless options.empty?
      self.class_name = options[:class_name] unless options[:class_name].nil?
      self.primary_key = options[:primary_key] unless options[:primary_key].nil?
      self.foreign_key = options[:foreign_key] unless options[:foreign_key].nil?
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    # ...
    self.class_name = "#{name.capitalize.to_s.singularize}"
    self.primary_key = :id
    self.foreign_key = :"#{self_class_name.to_s.singularize.downcase}_id"

    unless options.empty?
      self.class_name = options[:class_name] unless options[:class_name].nil?
      self.primary_key = options[:primary_key] unless options[:primary_key].nil?
      self.foreign_key = options[:foreign_key] unless options[:foreign_key].nil?
    end
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    # ...
    options = BelongsToOptions.new(name,options)
    assoc_options
    @assoc_options[name] = options
    define_method("#{name}") do
      f_key = options.send("foreign_key")
      puts "belongs_to f key: #{f_key}"
      mod_class = options.send("model_class")
      thing = mod_class.where({:id => self.attributes[f_key]}).first
      thing
    end


  end

  def has_many(name, options = {})
    # ...
    options = HasManyOptions.new(name, self, options)
    #get all the cats with the same human id
    define_method("#{name}") do
      f_key = options.send("foreign_key")
      mod_class = options.send("model_class")
      id = self.id
      thing = mod_class.where({f_key => id})
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
    @assoc_options ||= {}
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
