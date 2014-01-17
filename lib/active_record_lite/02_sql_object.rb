require_relative 'db_connection'
require_relative '01_mass_object'
require 'active_support/inflector'

class MassObject
  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end
end

class SQLObject < MassObject
  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    if @table_name.nil?
      self.to_s.downcase.pluralize.underscore
    else
      @table_name
    end
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
      SQL

    self.parse_all(results)
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL, id)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
      WHERE
        id = ?
    SQL

    self.parse_all(results).first
  end

  def insert
    col_names = self.class.attributes.map {|a| a.to_s}.join(",")
    question_marks = ("?" * (self.attribute_values.count)).split("").join(",")

    DBConnection.execute(<<-SQL, attribute_values)
     INSERT INTO
      #{self.class.table_name} (#{col_names})
     VALUES
      (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def save
    if self.id.nil?
      self.insert
    else
      self.update
    end
  end

  def update
    sets = self.class.attributes.map do |col_name|
      "#{col_name} = '#{self.send(col_name)}'"
    end.join(",")

    DBConnection.execute(<<-SQL, self.id)
     UPDATE
      #{self.class.table_name}
     SET
      #{sets}
     WHERE
      id = ?
    SQL
  end

  def attribute_values
    self.class.attributes.map { |name| self.send(name) }
  end
end
