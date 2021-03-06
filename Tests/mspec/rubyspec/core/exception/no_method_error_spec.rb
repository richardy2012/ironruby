require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/common'

describe "NoMethodError.new" do
  it "can be called with no arguments" do
    NoMethodError.new().should_not be_nil
  end
  
  it "can be called with upto 3 arguments" do
    NoMethodError.new("msg", "name", ["arg1", "arg2"]).should_not be_nil
  end

  it "allows passing nil" do
    NoMethodError.new(nil, nil, nil).should_not be_nil
  end

  it "can be called with arbitrary objects" do
    m = mock("some object")
    NoMethodError.new(m, m, m).should_not be_nil
  end
end

describe "NoMethodError#args" do
  it "returns an empty array if the caller method had no arguments" do
    begin
      NoMethodErrorSpecs::NoMethodErrorB.new.foo
    rescue Exception => e
      e.args.should == []
    end
  end

  it "returns an array with the same elements as passed to the method" do
    begin
      a = NoMethodErrorSpecs::NoMethodErrorA.new
      NoMethodErrorSpecs::NoMethodErrorB.new.foo(1,a)
    rescue Exception => e
      e.args.should == [1,a]
      e.args[1].should equal(a)
    end
  end
end

describe "NoMethodError#message" do
  it "for an undefined method match /undefined method/" do
    begin
      NoMethodErrorSpecs::NoMethodErrorD.new.foo
    rescue Exception => e
      e.class.should == NoMethodError
    end
  end

  it "for an protected method match /protected method/" do
    begin
      NoMethodErrorSpecs::NoMethodErrorC.new.a_protected_method
    rescue Exception => e
      e.class.should == NoMethodError
    end
  end

  not_compliant_on :rubinius do
    it "for private method match /private method/" do
      begin
        NoMethodErrorSpecs::NoMethodErrorC.new.a_private_method
      rescue Exception => e
        e.class.should == NoMethodError
        e.message.match(/private method/).should_not == nil
      end
    end
  end
end
