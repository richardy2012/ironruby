require File.dirname(__FILE__) + '/../../spec_helper'

ruby_version_is "1.9" do
  describe "Regexp.try_convert" do
    it "returns the argument if given a Regexp" do
      Regexp.try_convert(/foo/s).should == /foo/s
    end

    it "returns nil if given an argument that can't be converted to a Regexp" do
      ['', 'glark', [], Object.new, :pat].each do |arg|
        Regexp.try_convert(arg).should be_nil
      end
    end

    it "tries to coerce the argument by calling #to_regexp" do
      rex = mock('regexp')
      rex.should_receive(:to_regexp).and_return(/(p(a)t[e]rn)/)
      Regexp.try_convert(rex).should == /(p(a)t[e]rn)/
    end
  end
end
