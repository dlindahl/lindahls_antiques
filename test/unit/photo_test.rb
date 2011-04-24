require File.dirname(__FILE__) + '/../test_helper'

class PhotoTest < ActiveSupport::TestCase

  should have_db_column(:antique_id)
  should have_db_column(:width)
  should have_db_column(:height)
  should have_db_column(:title)
  should have_db_column(:size)
  should have_db_column(:url)
  should have_db_column(:page)

  should validate_presence_of(:title)
  should validate_presence_of(:page)
  should validate_presence_of(:url)

  should validate_numericality_of(:width)
  should validate_numericality_of(:height)

  should_not allow_value(nil).for(:width)
  should_not allow_value(nil).for(:height)

  should allow_value('small').for(:size)
  should_not allow_value(nil).for(:size)
  should_not allow_value('foo').for(:size)

  should belong_to(:antique)

  context "When there are photos of varying sizes," do
    setup do
      Photo::SIZES.each { |size| Photo.make(:size => size) }
    end
    Photo::SIZES.each do |size|
      context "##{size}" do
        should "find only the photos with a size of #{size}" do
          assert_equal 1, Photo.send(size).size
        end
      end
    end
  end

  context "Photo.fetch" do
    context "with a valid SKU" do
      setup do
        fleakr_user = mock('fleakr_user')
        @fleakr_photo = mock('fleakr_photo')
        sku_as_tag = "abc123"

        Fleakr.expects(:user).returns(fleakr_user)
        Photo.send(:class_variable_set, "@@flickr_user", nil ) # Ensures the memoization is cleared from any previous tests
        fleakr_user.expects(:search).with(:tags => sku_as_tag).returns( [@fleakr_photo] )

        @photos = Photo.fetch( sku_as_tag )
      end
      should "add the Flickr photos to the Database" do
        assert_equal [@fleakr_photo], @photos
      end
    end
  end

end
