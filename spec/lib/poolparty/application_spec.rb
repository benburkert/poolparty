require File.dirname(__FILE__) + '/../../spec_helper'

describe "Application" do
  before(:each) do
    stub_option_load
    Application.stub!(:keypair).and_return("testappkeypair")
  end
  after(:each) do
    Application.reset!
  end
  describe "command line options" do
    it "should destroy the default options with the commandline options" do
      ARGV << ["-k", "testappkeypair"]
      ARGV.should_receive(:dup).and_return ARGV
      PoolParty.options.keypair.should == "testappkeypair"      
    end
  end
  it "should have the root_dir defined" do
    PoolParty.root_dir.should_not be_nil
  end
  it "should be able to call on the haproxy_config_file" do
    Application.haproxy_config_file.should_not be_nil
  end
  it "should be able to find the client_port" do
    Application.options.should_receive(:client_port).and_return(7788)
    Application.client_port.should == 7788
  end
  it "should always have cloud_master_takeover in the managed services list" do
    Application.master_managed_services.should =~ /cloud_master_takeover/
  end
  it "should be able to say it is in development mode if it is in dev mode" do
    Application.stub!(:environment).and_return("development")
    Application.development?.should == true
  end
  it "should be able to say it is in production if it is in production" do
    Application.stub!(:environment).and_return("production")
    Application.production?.should == true
  end
  describe "keypair" do
    before(:each) do
      Application.stub!(:ec2_dir).and_return("~/.ec2")
      Application.stub!(:keypair).and_return("poolparty")
    end
    it "should be able to say it's keypair path is in the $HOME/ directory" do      
      Application.keypair_path.should == "~/.ec2/id_rsa-poolparty"
    end
    it "should be able to say the keypair is of the structure id_rsa-keyname" do
      Application.keypair_name.should == "id_rsa-poolparty"
    end
  end
  it "should be able to show the version of the gem" do
    Application.version.should_not be_nil
  end
  it "should show the version as a string" do
    Application.version.class.should == String
  end
  describe "User data" do
    before(:each) do
      @str = ":access_key: 3.14159\n:secret_access_key: pi"
      Application.options = nil
      Application.stub!(:open).with("http://169.254.169.254/latest/user-data").and_return(@str)
      @str.stub!(:read).and_return ":access_key: 3.14159\n:secret_access_key: pi"
      @launch_hash = {:_remote_instance => true, :access_key=>3.14159, :keypair_path=>"/mnt", :keypair=>"testappkeypair", :secret_access_key=>"pi", :user_data=>"", :polling_time=>"30.seconds"}
    end
    describe "added data keypair_path" do
      before(:each) do
        @str.stub!(:read).and_return ":access_key: 3.14159\n:secret_access_key: pi\n:keypair_path: hopscotch"
      end
      it "should use the options keypair_path if it exists" do
        Application.keypair_path.should == "hopscotch"
      end
    end
    it "should try to load the user data into a yaml hash" do
      YAML.should_receive(:load).with(":access_key: 3.14159\n:secret_access_key: pi")
      Application.local_user_data
    end
    it "should be able to start instances with the the key access information on the user-data" do
      Application.launching_user_data.should =~ /:access_key/
      Application.launching_user_data.should =~ /:secret_access_key/
    end
    it "should be able to pull out the access_key from the user data" do
      Application.local_user_data[:access_key].should == 3.14159
    end
    it "should be able tp pull out the secret_access_key from the user-data" do
      Application.local_user_data[:secret_access_key].should == "pi"
    end
    it "should not have the application name in the user-data" do
      Application.local_user_data[:application_name].should be_nil
    end
    it "should have the application_name in the options even though it is nil in the application" do
      Application.options.app_name.should_not be_nil
    end
    it "should overwrite the default_options when passing in to the instance data" do      
      Application.stub!(:default_options).and_return({:access_key => 42})
      Application.options.access_key.should == 3.14159
    end
    it "should have the required lauching hash" do
      Application.hash_to_launch_with.should == @launch_hash
    end
    it "should create the hash_to_launch_with a YAML string" do
      Application.launching_user_data.should == Application.hash_to_launch_with.to_yaml
    end
    describe "_remote_instance option" do
      it "should say that the instance is not a remote instance by default" do
        Application.stub!(:local_user_data).and_return nil
        Application.remote_instance?.should == false
      end
      it "should be a remote instance when the local_user_data is true" do
        Application.stub!(:local_user_data).and_return @launch_hash
        Application.remote_instance?.should == true
      end
    end
  end
  it "should parse and use a config file if it is given for the options" do
    YAML.should_receive(:load).at_least(1).and_return({:config_file => "config/sample-config.yml"})
    Application.make_options(:config_file => "config/sample-config.yml")
  end
  describe "config file" do
    before(:each) do
      @str = ":access_key: 3.14159\n:secret_access_key: pi"
      Application.options = nil
      @str.stub!(:read).and_return ":access_key: 3.14159\n:secret_access_key: pi"
      Application.make_options
    end
    it "should read the config file and use the options in the config file if it exists" do      
      Application.access_key.should == 3.14159
    end
    it "should set the secret_access_key if the config file exists" do
      Application.secret_access_key.should == "pi"
    end
  end
  it "should not read the config file if it is not passed and doesn't exist" do
    File.stub!(:file?).and_return false
    YAML.should_not_receive(:load).with("config/config.yml")
    Application.make_options
  end
  it "should not read the config file if it is passed and doesn't exist" do
    File.stub!(:file?).and_return false
    YAML.should_not_receive(:load).with("config/config.yml")
    Application.make_options(:config_file => "ted")
  end
end