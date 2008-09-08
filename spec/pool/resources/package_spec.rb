require File.dirname(__FILE__) + '/../../spec_helper'

include PoolParty::Resources

describe "Package" do
  before(:each) do
    @package = PoolParty::Resources::Package.new
  end
  it "should have instances of Packages" do
    @package.respond_to?(:instances).should == true
  end
  describe "instances" do
    before(:each) do
      package({:name => "/etc/apache2/puppetmaster.conf"})
    end
    it "should turn the one hash instance into a string" do
      package.to_string.should =~ /\/etc\/apache2\/puppetmaster\.conf:/      
    end
    it "should turn the two hash instance into a string" do
      package({:name => "/etc/init.d/puppetmaster"})
      package.to_string.should =~ /etc\/init\.d\/puppetmaster:/
    end
    describe "as included" do            
      before(:each) do
        package({:rent => "low"}) do
          name "/www/conf/httpd.conf"
        end
        @package = package.instance_named("/www/conf/httpd.conf")
      end
      it "should use default values" do
        @package.name.should == "/www/conf/httpd.conf"
      end
      it "should keep the default values for the Package" do
        @package.alias.should == nil
      end
      it "should also set options through a hash" do
        @package.rent.should == "low"
      end
    end
  end
end