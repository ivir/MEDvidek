require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "Builder::App::BuildHelper" do
  setup do
    helpers = Class.new
    helpers.extend Builder::App::BuildHelper
    [helpers.foo]
  end

  asserts("#foo"){ topic.first }.nil
end
