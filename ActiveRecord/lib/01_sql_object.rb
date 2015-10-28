require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    # ...
    cols = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        "#{self.table_name}"

    SQL

    cols = cols.first
    cols = cols.map {|name| name.to_sym}
    cols
  end

  def self.finalize!
    cols = self.columns
    cols.each do |name|
      define_method("#{name}") do
        self.attributes[name]
      end

      define_method("#{name}=") do |value|
        self.attributes[name] = value
      end
    end

  end

  def self.table_name=(table_name)
    # ...
    instance_variable_set("@table_name", table_name)
  end

  def self.table_name
    # ...
    if instance_variable_get("@table_name").nil?
      instance_variable_set("@table_name", self.to_s.tableize)
    end
    instance_variable_get("@table_name")
  end

  def self.all
    # ...
    hashes = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    parse_all(hashes)
  end

  def self.parse_all(results)
    # ...

    instance_array = []
    results.each do |hash|
      instance_array << self.new(hash)
    end

    instance_array
  end

  def self.find(id)
    # ...
    hash = DBConnection.execute(<<-SQL, {id: id}).first
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = :id
    SQL

    return hash unless hash

    self.new(hash)
  end

  def initialize(params = {})
    # ...
    params.keys.each do |key|
      unless self.class.columns.include?(key.to_sym)
        raise "unknown attribute '#{key}'"
      end

      # attributes[key] = params[key]
      self.send("#{key.to_sym}=", params[key])
    end

  end

  def attributes
    # ...
    if @attributes.nil?
      @attributes = {}
    end
    @attributes
  end

  def attribute_values
    # ...
    @attributes.values
  end

  def insert
    # ...
    # col_name = self.class.columns

    col_names = '(' + attributes.keys.join(', ') + ')'
    question_marks = ['?'] * attributes.keys.length
    question_marks = '(' + question_marks.join(', ') + ')'

    # col_values = col_name.map do |col|
    #   send("#{col}")
    # end
    # puts "column values are: #{col_values}"

    a_values = attribute_values

    data = DBConnection.execute(<<-SQL, a_values ).first
      INSERT INTO
        #{self.class.table_name} #{col_names}
      VALUES
        #{question_marks}
      SQL
    attributes[:id] = DBConnection.last_insert_row_id

  end

  def update
    # ...
    col_names = attributes.keys - [:id]
    question_marks = ['?'] * col_names.length
    col_names =  col_names.join(' = ?,') + ' = ?'
    question_marks = '(' + question_marks.join(', ') + ')'

    a_values = []


    a_values = attribute_values - [attributes[:id]]
    id = attributes[:id]
    a_values << id

    puts "updatessss"
    puts "#{col_names}"
    puts "#{question_marks}"
    puts "#{a_values}"
    puts "#{id}"


    data = DBConnection.execute(<<-SQL, a_values)
      UPDATE
        #{self.class.table_name}
      SET
        #{col_names}
      WHERE
        id = ?
      SQL

  end

  def save
    # ...

    if attributes[:id].nil?
      insert
    else
      update
    end

  end
end
