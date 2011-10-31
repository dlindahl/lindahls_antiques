require File.dirname(__FILE__) + '/../../test_helper'

class MockPhoto
  SIZES = %w{small square}

  include Behaviors::Photo
end

class BehaviorsPhotoTest < ActiveSupport::TestCase
  context "#fetch" do
    context "with a valid SKU" do
      setup do
        sku_as_tag = "test101"
        MockPhoto.send(:class_variable_set, "@@flickr_user", nil ) # Ensures the memoization is cleared from any previous tests

        VCR.use_cassette('flickr_fetch') do
          @photos = MockPhoto.fetch( sku_as_tag )
        end
      end
      should "add the Flickr photos to the Database" do
        assert_equal 4, @photos.size
        assert @photos.first.is_a? Fleakr::Objects::Photo
      end
    end
  end

  context "looking up a different size for given sized photo" do
    setup { MockPhoto.new.small }

    before_should "return the requested sized image" do
      arel = mock('arel')
      arel.expects(:where).with(:flickr_id => 123).returns([])

      MockPhoto.any_instance.stubs(:flickr_id).returns(123)
      MockPhoto.expects(:small).returns(arel)
    end
  end

end
