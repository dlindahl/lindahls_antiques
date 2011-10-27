# require 'test_helper'
# 
# class Admin::DashboardControllerTest < ActionController::TestCase
#   include Devise::TestHelpers
# 
#   context "As an Admin user," do
#     setup do
#       @user = User.make(:password => 'foobarbaz', :admin => true)
#       sign_in @user
#     end
#     context "a GET to" do
#       context ":index" do
#         setup { get :index }
#         should respond_with(:success)
#       end
#     end
#   end
#   context "As a User," do
#     setup do
#       @user = User.make(:password => 'foobarbaz')
#       sign_in @user
#     end
#     context "a GET to" do
#       context ":index" do
#         setup { get :index }
#         should respond_with(:redirect)
#       end
#     end
#   end
# end
