require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    # ...
    col_names = params.keys
    params_values = []
    col_names.each do |key|
      params_values << params[key]
    end

    col_names =  col_names.join(' = ? AND ') + ' = ?'

    puts "where"
    puts "#{col_names}"
    puts "#{params_values}"


    data = DBConnection.execute(<<-SQL, params_values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{col_names}
      SQL


    parse_all(data)
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end
