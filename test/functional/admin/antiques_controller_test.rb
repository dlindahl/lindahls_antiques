require 'test_helper'

class Admin::AntiquesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  context "As an Admin user," do
    setup do
      @user = User.make(:password => 'foobarbaz', :admin => true)
      sign_in @user
    end
    context "a GET to" do
      context ":index" do
        setup { get :index }
        should assign_to(:antiques)
        should respond_with(:success)
      end
    end
  end
end
