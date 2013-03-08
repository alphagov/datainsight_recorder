require_relative "../spec_helper"
require_relative "../../lib/datainsight_recorder/datamapper_config"

module GoodDataMapperConfig
  extend DataInsight::Recorder::DataMapperConfig

  def self.development_uri
    "development uri"
  end

  def self.production_uri
    "production uri"
  end

  def self.test_uri
    "test uri"
  end
end

module BadDataMapperConfig
  extend DataInsight::Recorder::DataMapperConfig
end

describe "DataMapperConfig" do
  describe "automatic" do
    describe "configure" do
      before(:each) do
        @temp_rack_env = ENV["RACK_ENV"]
        @temp_rails_env = ENV["RAILS_ENV"]

        ENV.delete("RACK_ENV")
        ENV.delete("RAILS_ENV")

        DataMapper.should_receive(:finalize)
      end

      after(:each) do
        ENV["RACK_ENV"] = @temp_rack_env
        ENV["RAILS_ENV"] = @temp_rails_env
      end

      it "should default to development" do
        DataMapper.should_receive(:setup).with(:default, "development uri")
        GoodDataMapperConfig.configure
      end

      it "should select the production environment if RACK_ENV is set to development" do
        ENV["RACK_ENV"] = "production"

        DataMapper.should_receive(:setup).with(:default, "production uri")

        GoodDataMapperConfig.configure
      end

      it "should select the production environment if RAILS_ENV is set to development" do
        ENV["RAILS_ENV"] = "production"

        DataMapper.should_receive(:setup).with(:default, "production uri")

        GoodDataMapperConfig.configure
      end
    end
  end

  describe "development" do
    describe "configure" do
      before(:each) do
        DataMapper.should_receive(:setup).with(:default, "development uri")
        DataMapper.should_receive(:finalize)
      end

      it "should configure datamapper" do
        GoodDataMapperConfig.configure_development
      end

      it "should select the right configuration" do
        DataMapper::Model.should_receive(:"raise_on_save_failure=").with(true)

        GoodDataMapperConfig.configure(:development)
      end
    end

    it "should fail to configure" do
      lambda{ BadDataMapperConfig.configure_development }.should raise_error(NotImplementedError)
    end
  end

  describe "production" do
    describe "configure" do
      before(:each) do
        DataMapper.should_receive(:setup).with(:default, "production uri")
        DataMapper.should_receive(:finalize)
      end

      it "should configure datamapper" do
        GoodDataMapperConfig.configure_production
      end

      it "should select the right configuration" do
        DataMapper::Model.should_receive(:"raise_on_save_failure=").with(true)

        GoodDataMapperConfig.configure(:production)
      end
    end

    it "should fail to configure" do
      lambda{ BadDataMapperConfig.configure_production }.should raise_error(NotImplementedError)
    end
  end

  describe "test" do
    describe "configure" do
      before(:each) do
        DataMapper.should_receive(:setup).with(:default, "test uri")
        DataMapper.should_receive(:finalize)
      end

      it "should configure datamapper" do
        GoodDataMapperConfig.configure_test
      end

      it "should select the right configuration" do
        DataMapper::Model.should_receive(:"raise_on_save_failure=").with(true)

        GoodDataMapperConfig.configure(:test)
      end
    end

    it "should fail to configure" do
      lambda{ BadDataMapperConfig.configure_test }.should raise_error(NotImplementedError)
    end
  end
end