require "dm-migrations"

module DataMapper
  module Migrations
    module MysqlAdapter
      def index_exists?(name, table)
        statement = "show index from #{quote_name(table)} where key_name = ?"
        select(statement, name).count > 0
      end

      def drop_index(table, name)
        statement = "alter table #{quote_name(table)} drop index #{quote_name(name)}"
        execute(statement)
      end
    end
  end
end

