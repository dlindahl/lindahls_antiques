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
      context ":show" do
        setup { get :show, :id => Antique.make }
        should assign_to(:antique)
        should respond_with(:success)
      end
      context ":new" do
        setup { get :new }
        should assign_to(:antique)
        should respond_with(:success)
      end
    end
    context "a POST to" do
      context ":create" do
        context "with valid Antique parameters" do
          setup do
            @antique = Antique.make_unsaved
            post :create, :antique => @antique.attributes
          end
          should assign_to(:antique)
          should set_the_flash.to("Antique was created successfully")
          should respond_with(:redirect)
        end
        context "with invalid Antique parameters" do
          setup { post :create, :antique => {} }
          should render_template(:new)
        end
      end
    end
  end
end
