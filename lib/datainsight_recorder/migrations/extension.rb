require "dm-migrations"

module DataMapper
  module Migrations
    module MysqlAdapter
      def index_exists?(name, table)
        statement = "show index from #{quote_name(table)} where key_name = ?"
        select(statement, name).count > 0
      end
    end
  end
end

