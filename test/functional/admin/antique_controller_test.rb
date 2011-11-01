require File.dirname(__FILE__) + '/../../test_helper'

class Admin::AntiquesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  context "As an Admin user," do
    setup do
      @user = AdminUser.make
      sign_in @user
    end
    context "a GET to" do
      context ":index" do
        setup { get :index }
        should assign_to(:antiques)
        should respond_with(:success)
      end
      context ":show" do
        setup do
          VCR.use_cassette('flickr_fetch') do
            get :show, :id => Antique.make.id
          end
        end
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
          VCR.use_cassette('flickr_fetch') do
            @antique = Antique.make
          end
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
            VCR.use_cassette('flickr_fetch') do
              post :create, :antique => @antique.attributes
            end
          end
          should assign_to(:antique)
          should set_the_flash.to("Antique was successfully created.")
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
        setup do
          VCR.use_cassette('flickr_fetch') do
            @antique = Antique.make
          end
        end
        context "with valid Antique parameters" do
          setup { put :update, :id => @antique.id, :antique => @antique.attributes.merge('name' => "ZOMG!") }
          should assign_to(:antique)
          should set_the_flash.to("Antique was successfully updated.")
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