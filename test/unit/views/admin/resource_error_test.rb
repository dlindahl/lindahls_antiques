require File.dirname(__FILE__) + '/../../../test_helper'

class Admin::ResourceErrorTest < ActiveSupport::TestCase
  Admin::ResourceError.send(:include, ActionView::Helpers::TextHelper)

  subject do
    Admin::ResourceError.new.tap do |mock|
      resource = mock('MockResource')
      resource.stubs(:class).returns('EbayAuction')
      resource.stubs(:errors).returns( stub(:size => 2, :full_messages => ["Title can't be blank"]) )

      mock.stubs(:resource).returns( resource )
    end
  end

  should "return the Class in a human readable format" do
    assert_equal "Ebay Auction", subject.resource_name
  end

  should "return a pluralized number of errors" do
    assert_equal "2 errors", subject.number_of_errors
  end

  should "return all of the resources full error messages" do
    assert_equal [ "Title can't be blank" ], subject.errors
  end

end