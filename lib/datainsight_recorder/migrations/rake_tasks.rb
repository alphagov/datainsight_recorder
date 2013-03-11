require 'dm-migrations/migration_runner'

require_relative "../datamapper_config"

namespace :db do
  task :configure do
    DataInsight::Recorder::DataMapperConfig.configure
  end

  namespace :migrate do

    desc "Run all pending migrations"
    task :up => :load_migrations do
      migrate_up!
    end

    desc "Rollback last migration"
    task :down => :load_migrations do
      migration = DataMapper.migrations.sort.reverse.find { |migration| migration.needs_down? }
      migration.perform_down
    end

    desc "Show current status of migrations"
    task :status => :load_migrations do
      puts "Status of migrations on schema #{DataMapper.repository.adapter.schema_name}"

      DataMapper.migrations.sort.each do |migration|
        puts "#{migration.needs_down? ? '   UP' : ' DOWN'} : #{migration.position}. #{migration.name}"
      end
    end

    task :load_migrations => "db:configure" do
      FileList['db/migrate/*.rb'].each do |migration|
        load migration
      end
    end
  end

  task :migrate => "migrate:up"
end
