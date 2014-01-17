require_relative 'db_connection'
require_relative '02_sql_object'

module Searchable
  def where(params)
    wheres = params.map do |col, value|
      "#{col} = '#{value}'"
    end.join(" AND ")

    results = DBConnection.execute(<<-SQL)
      SELECT
       *
      FROM
       #{self.table_name}
      WHERE
       #{wheres}
    SQL

    self.parse_all(results)
  end
end

class SQLObject
  extend Searchable
end
