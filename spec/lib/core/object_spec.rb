require File.dirname(__FILE__) + '/../../spec_helper'

describe "Object" do
  it "should respond to to_os" do
    Object.new.respond_to?(:to_s).should == true
  end
end