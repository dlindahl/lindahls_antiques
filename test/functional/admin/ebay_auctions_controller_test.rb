require 'test_helper'

class Admin::EbayAuctionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  context "As an Admin user," do
    setup do
      @user = User.make(:password => 'foobarbaz', :admin => true)
      sign_in @user
    end
    context "working with a specific Antique," do
      setup { @antique = Antique.make }
      context "a GET to" do
        context ":index" do
          setup do
            EbayAuction.make(:antique => @antique)
            get :index, :antique_id => @antique.id
          end
          should assign_to(:antique)
          should assign_to(:ebay_auctions)
          should respond_with(:success)
        end
        context ":show" do
          setup { get :show, :antique_id => @antique.id, :id => EbayAuction.make(:antique => @antique).id }
          should assign_to(:antique)
          should assign_to(:ebay_auction)
          should respond_with(:success)
          # should "parse the Markdown syntax in description" do
          #   assert_select ".description em"
          # end
        end
        context ":new" do
          setup { get :new, :antique_id => @antique.id }
          should assign_to(:antique)
          should assign_to(:ebay_auction)
          should respond_with(:success)
          should "build the default Title from the parent Antique" do
            assert_equal assigns(:antique).name, assigns(:ebay_auction).title
          end
          should "build the default Description from the parent Antique" do
            assert_equal assigns(:antique).description, assigns(:ebay_auction).description
          end
        end
        context ":edit" do
          setup do
            @ebay_auction = EbayAuction.make(:antique => @antique)
            get :edit, :antique_id => @antique.id, :id => @ebay_auction.id
          end
          should assign_to(:antique)
          should assign_to(:ebay_auction)
          should render_template(:edit)
        end
      end
      context "a POST to" do
        context ":create" do
          context "with valid EbayAuction parameters" do
            setup do
              @ebay_auction = EbayAuction.make_unsaved(:antique => @antique)
              post :create, :antique_id => @antique.id, :ebay_auction => @ebay_auction.attributes
            end
            should assign_to(:antique)
            should assign_to(:ebay_auction)
            should set_the_flash.to("Ebay Auction was created successfully")
            should respond_with(:redirect)
          end
          context "with invalid EbayAuction parameters" do
            setup { post :create, :antique_id => @antique.id, :ebay_auction => {} }
            should_not set_the_flash
            should render_template(:new)
          end
        end
      end
      context "a PUT to" do
        context ":update" do
          setup { @ebay_auction = EbayAuction.make(:antique => @antique) }
          context "with valid EbayAuction parameters" do
            setup { put :update, :antique_id => @antique.id, :id => @ebay_auction.id, :ebay_auction => @ebay_auction.attributes.merge('title' => "ZOMG!") }
            should assign_to(:antique)
            should assign_to(:ebay_auction)
            should set_the_flash.to("Ebay Auction was updated successfully")
            should respond_with(:redirect)
          end
          context "with invalid EbayAuction parameters" do
            setup { put :update, :antique_id => @antique.id, :id => @ebay_auction.id, :ebay_auction => @ebay_auction.attributes.merge('title' => '') }
            should assign_to(:antique)
            should assign_to(:ebay_auction)
            should_not set_the_flash
            should respond_with(:success)
          end
        end
      end
      context "a DELETE to" do
        context ":destroy" do
          setup do
            @ebay_auction = EbayAuction.make(:antique => @antique)
            delete :destroy, :antique_id => @antique.id, :id => @ebay_auction.id
          end
          should assign_to(:antique)
          should assign_to(:ebay_auction)
          should set_the_flash.to("Ebay Auction was destroyed successfully")
          should respond_with(:redirect)
        end
      end
    end
  end
end
