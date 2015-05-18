require "vagrant-vrealize/config"
require 'rspec/its'

describe VagrantPlugins::VRealize::Config do
  let(:instance) { described_class.new }

  # Ensure tests are not affected by environment variables
  before :each do
    ENV.stub(:[] => nil)
  end

  describe "defaults" do
    subject do
      instance.tap do |o|
        o.finalize!
      end
    end

    its("host")                 { should be_nil }
    its("username")             { should be_nil }
    its("password")             { should be_nil }
    its("authorization_token")  { should be_nil }
    its("tenant")               { should be_nil }
    its("catalog_item_name")    { should be_nil }
    its("request_description")  { should == "Default Request Description" }
  end

  describe "overriding defaults" do
    # I typically don't meta-program in tests, but this is a very
    # simple boilerplate test, so I cut corners here. It just sets
    # each of these attributes to "foo" in isolation, and reads the value
    # and asserts the proper result comes back out.
    [:host, :username, :password, :authorization_token, :catalog_item_name, :request_description, :tenant].each do |attribute|

      it "should not default #{attribute} if overridden" do
        instance.send("#{attribute}=".to_sym, "foo")
        instance.finalize!
        instance.send(attribute).should == "foo"
      end
    end
  end
end
