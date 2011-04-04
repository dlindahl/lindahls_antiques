require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  context "As a User" do
    context "with Admin privileges," do
      setup do
        @user = User.make(:password => 'foobarbaz', :admin => true)
        sign_in @user
      end
      context "a GET to" do
        context ":index" do
          setup { get :index }
          should redirect_to("the Dashboard") { admin_dashboard_path }
        end
      end
    end
    context "without Admin privileges," do
      setup do
        @user = User.make(:password => 'foobarbaz')
        sign_in @user
      end
      context "a GET to" do
        context ":index" do
          setup { get :index }
          should redirect_to('')
          should set_the_flash.to("Not authorized")
        end
      end
    end
  end

end