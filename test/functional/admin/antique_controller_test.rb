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
        setup do
          VCR.use_cassette('flickr_fetch') do
            Antique.make
          end
          get :index
        end
        should assign_to(:antiques)
        should respond_with(:success)
      end
      context ":show" do
        context "with Photos" do
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
          should "include an button to Auction Off the item" do
            assert_select '.action_item', :text => 'Auction Off!'
          end
        end
        context "without Photos" do
          setup do
            Photo.stubs(:fetch).returns([])
            get :show, :id => Antique.make.id
          end
          should "offer the oppotunity to refresh the photos" do
            assert_select '#photos_sidebar_section a', :text => 'Refresh?'
          end
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
          should set_the_flash.to %r{Oops! We found 7 errors with your Antique}
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
          should set_the_flash.to %r{Oops! We found 1 error with your Antique}
          should respond_with(:success)
        end
      end
    end
  end
end