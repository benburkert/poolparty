require File.dirname(__FILE__) + '/spec_helper'

describe "String" do
  before(:each) do
    @string = "string"
    @string.stub!(:bucket_objects).and_return([])
  end
  # Dumb test
  it "should be able to call bucket_objects on itself" do
    @string.should_receive(:bucket_objects)
    @string.bucket_objects
  end
  describe "with config replacements" do
    it "should replace those syms in the string" do
      ("new :port" ^ {:port => 100}).should == "new 100"
    end
    it "should be able to detect vars" do
      @string=<<-EOC
listen web_proxy 127.0.0.1::client_port
\tserver web1 127.0.0.1::port weight 1 minconn 3 maxconn 6 check inter 30000
      EOC
      (@string ^ {:client_port => 3000, :port => 3001}).should ==<<-EOO
listen web_proxy 127.0.0.1:3000
\tserver web1 127.0.0.1:3001 weight 1 minconn 3 maxconn 6 check inter 30000
      EOO
    end
  end
end