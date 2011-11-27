require File.expand_path( File.dirname(__FILE__) + '/../../test_helper' )

class Admin::EbayAuctionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  context "As an Admin user," do
    setup do
      @user = AdminUser.make
      sign_in @user
    end
    context "working with a specific Antique," do
      setup do
        VCR.use_cassette('flickr_fetch') do
          @antique = Antique.make
        end
      end
      context "a GET to" do
        context ":index" do
          should "be forbidden" do
            assert_raises HTTPStatus::Forbidden do
              get :index
            end
          end
        end
        context ":show" do
          setup do
            @params = { :antique_id => @antique.id }
          end
          context "for an Auction with a state of" do
            context "draft" do
              setup { get :show, @params.merge( :id => EbayAuction.make(:antique => @antique).id ) }
              should respond_with(:success)
              should_eventually "parse the Markdown syntax in description" do
                assert_select ".description em"
              end
              should %q{display a "List Now" button} do
                assert_select "button", :text => "List Now!"
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
          should assign_to(:ebay_auction)
          should respond_with(:success)
          should "build the default Title from the parent Antique" do
            assert_equal assigns(:ebay_auction).antique.name, assigns(:ebay_auction).title
          end
          should "build the default Description from the parent Antique" do
            assert_equal assigns(:ebay_auction).antique.description, assigns(:ebay_auction).description
          end
        end
        context ":edit" do
          setup do
            @ebay_auction = EbayAuction.make(:antique => @antique)
            get :edit, :antique_id => @antique.id, :id => @ebay_auction.id
          end
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
            should assign_to(:ebay_auction)
            should "create an association from Antique" do
              assert_equal @antique, assigns(:ebay_auction).antique
            end
            should set_the_flash.to("Ebay auction was successfully created.")
            should respond_with(:redirect)
          end
          context "with invalid EbayAuction parameters" do
            setup { post :create, :antique_id => @antique.id, :ebay_auction => {} }
            should set_the_flash.to %r{Oops! We found 5 errors}
            should render_template(:new)
          end
        end
        context ":verify" do
          context "with a listable EbayAuction" do
            setup do
              @ebay_auction = EbayAuction.make(:antique => @antique)
              VCR.use_cassette('item_verification_success') do
                post :verify, :antique_id => @antique.id, :id => @ebay_auction.id
              end
            end
            should assign_to(:ebay_auction)
            should "prompt the user to accept additional listing fees" do
              assert_select 'button#accept'
            end
            should "allow the user to abort the listing" do
              assert_select 'a#cancel'
            end
          end
          context "with an unlistable EbayAuction" do
            setup do
              @ebay_auction = EbayAuction.make(:antique => @antique)
              @ebay_auction.stubs(:to_ebay_item).returns(Ebay::Types::Item.new({}))
              EbayAuction.stubs(:find_by_id).with(@ebay_auction.id.to_s).returns(@ebay_auction)

              VCR.use_cassette('item_verification_failure') do
                post :verify, :antique_id => @antique.id, :id => @ebay_auction.id
              end
            end
            should assign_to(:ebay_auction)
            should set_the_flash.to(/We found \d error/)
            should redirect_to('EbayAuction#show') { edit_admin_antique_ebay_auction_path( @antique, @ebay_auction ) }
          end
        end
      end
      context "a PUT to" do
        context ":update" do
          setup { @ebay_auction = EbayAuction.make(:antique => @antique) }
          context "with valid EbayAuction parameters" do
            setup { put :update, :antique_id => @antique.id, :id => @ebay_auction.id, :ebay_auction => @ebay_auction.attributes.merge('title' => "ZOMG!") }
            should assign_to(:ebay_auction)
            should set_the_flash.to("Ebay auction was successfully updated.")
            should respond_with(:redirect)
          end
          context "with invalid EbayAuction parameters" do
            setup { put :update, :antique_id => @antique.id, :id => @ebay_auction.id, :ebay_auction => @ebay_auction.attributes.merge('title' => '') }
            should assign_to(:ebay_auction)
            should set_the_flash.to %r{Oops! We found 1 error}
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
          should assign_to(:ebay_auction)
          should set_the_flash.to("Ebay auction was successfully destroyed.")
          should respond_with(:redirect)
        end
      end
    end
  end
end