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
  describe "development" do
    describe "configure" do
      before(:each) do
        DataMapper.should_receive(:setup).with(:default, "development uri")
        DataMapper.should_receive(:finalize)
        DataMapper.should_receive(:"auto_upgrade!")
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
        DataMapper.should_receive(:"auto_upgrade!")
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
        DataMapper.should_receive(:"auto_upgrade!")
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