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
          setup do
            @params = { :antique_id => @antique.id }
          end
          context "for an Auction with a state of" do
            context "draft" do
              setup { get :show, @params.merge( :id => EbayAuction.make(:antique => @antique).id ) }
              should assign_to(:antique)
              should respond_with(:success)
              # should "parse the Markdown syntax in description" do
              #   assert_select ".description em"
              # end
              should %q{display a "List Now" button} do
                assert_select "input[value=List Now!]"
              end
            end
            context "pending" do
              setup { get :show, @params.merge( :id => EbayAuction.make(:antique => @antique, :listing_status => 'pending').id ) }
              should %q{NOT display a "List Now" button} do
                assert_select "input", :text => "List Now!", :count => 0
              end
            end
            context "active" do
              setup { get :show, @params.merge( :id => EbayAuction.make(:antique => @antique, :listing_status => 'active').id ) }
              should %q{NOT display a "List Now" button} do
                assert_select "input", :text => "List Now!", :count => 0
              end
            end
            context "completed" do
              setup { get :show, @params.merge( :id => EbayAuction.make(:antique => @antique, :listing_status => 'completed').id ) }
              should %q{NOT display a "List Now" button} do
                assert_select "input", :text => "List Now!", :count => 0
              end
            end
            context "ended" do
              setup { get :show, @params.merge( :id => EbayAuction.make(:antique => @antique, :listing_status => 'ended').id ) }
              should %q{NOT display a "List Now" button} do
                assert_select "input", :text => "List Now!", :count => 0
              end
            end
          end
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
          context "with a listing status change" do
            context "to Pending" do
              setup { put :update, :antique_id => @antique.id, :id => @ebay_auction.id, :ebay_auction => { :listing_status => 'pending' } }
              should set_the_flash.to("The Ebay Auction will be listed soon!")
            end
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
