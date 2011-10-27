require File.dirname(__FILE__) + '/../../test_helper'

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
        setup { get :show, :id => Antique.make.id }
        should assign_to(:antique)
        should respond_with(:success)
        should "parse the Markdown syntax in description" do
          assert_select ".description em"
        end
      end
      context ":new" do
        setup { get :new }
        should assign_to(:antique)
        should respond_with(:success)
      end
      context ":edit" do
        setup do
          @antique = Antique.make
          get :edit, :id => @antique.id
        end
        should assign_to(:antique)
        should render_template(:edit)
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
          should_not set_the_flash
          should render_template(:new)
        end
      end
    end
    context "a PUT to" do
      context ":update" do
        setup { @antique = Antique.make }
        context "with valid Antique parameters" do
          setup { put :update, :id => @antique.id, :antique => @antique.attributes.merge('name' => "ZOMG!") }
          should assign_to(:antique)
          should set_the_flash.to("Antique was updated successfully")
          should respond_with(:redirect)
        end
        context "with invalid Antique parameters" do
          setup { put :update, :id => @antique.id, :antique => @antique.attributes.merge('width' => 0) }
          should assign_to(:antique)
          should_not set_the_flash
          should respond_with(:success)
        end
      end
    end
  end
end
