require File.dirname(__FILE__) + '/../../test_helper'

class Admin::PhotosControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # TODO: Not sure why this isn't passing...
  # should route(:get, "/admin/antiques/1/photos/refresh").to( :controller => "admin/photos", "action" => "refresh", "antique_id"=>"1" )

  context "As an Admin user," do
    setup do
      @user = AdminUser.make
      sign_in @user
    end
    context "a GET to" do
      context ":refresh" do
        context "with an Antique ID" do
          setup do
            VCR.use_cassette('flickr_fetch') do
              @antique = Antique.make
            end
          end
          context "that has photos" do
            context "with a format of" do
              context "HTML" do
                setup do
                  VCR.use_cassette('flickr_fetch') do
                    get :refresh, :antique_id => @antique.id, :format => :html
                  end
                end
                should respond_with(:redirect)
                should set_the_flash.to("Photos updated!")
              end
              context "JSON" do
                setup do
                  VCR.use_cassette('flickr_fetch') do
                    get :refresh, :antique_id => @antique.id, :format => :json
                  end
                end
                should respond_with(:success)
              end
            end
          end
          context "that does NOT have photos" do
            setup do
              Photo.expects(:fetch).with(@antique.sku_as_tag).returns( [] )
            end
            context "with a format of" do
              context "HTML" do
                setup { get :refresh, :antique_id => @antique.id, :format => :html }
                should respond_with(:redirect)
                should set_the_flash.to("No photos found!")
              end
              context "JSON" do
                setup { get :refresh, :antique_id => @antique.id, :format => :json }
                should respond_with(:no_content)
              end
            end
          end
        end
      end
    end
  end

end