require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

context "/build" do
  context "description here" do
    setup do
      get "/build"
    end

    asserts("the response body") { last_response.body }.equals "Hello World"
  end
end
