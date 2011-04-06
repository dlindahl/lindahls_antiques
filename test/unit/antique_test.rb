require File.dirname(__FILE__) + '/../test_helper'

class AntiqueTest < ActiveSupport::TestCase
  should have_db_column(:sku)
  should have_db_column(:name)
  should have_db_column(:description)
  should have_db_column(:width)
  should have_db_column(:height)
  should have_db_column(:depth)
  should have_db_column(:weight)

  should allow_value('DML-1').for(:sku)
  should allow_value('DML-123456789').for(:sku)
  should allow_value('DML-1234A').for(:sku)
  should_not allow_value(123).for(:sku)
  should_not allow_value('A-1').for(:sku)
  should_not allow_value('DML-1234AB').for(:sku)

  should validate_presence_of(:name)
  should validate_presence_of(:description)

  should validate_numericality_of(:weight)
  should validate_numericality_of(:width)
  should validate_numericality_of(:height)
  should validate_numericality_of(:depth)

  should_not allow_value(nil).for(:weight)
  should_not allow_value(nil).for(:width)
  should_not allow_value(nil).for(:height)
  should_not allow_value(nil).for(:depth)

  should have_many(:photos)

  context "A saved Antique" do
    subject { Antique.make }
    should validate_uniqueness_of(:sku)
  end

  context "An Antique" do
    subject { Antique.make_unsaved }
    should "create a Flickr tag from its SKU" do
      assert_equal "a123b", Antique.new(:sku => 'A-123B').sku_as_tag
    end
    context "with photos" do
      setup do
        @antique = subject
        @antique.photos = [ Photo.make_unsaved, Photo.make_unsaved ]
      end
      context "that are refreshed" do
        setup do
          @old_photos = @antique.photos.clone

          @fleakr_photos = [ stub('fleakr_photo', Photo.make_unsaved.attributes) ]

          Photo.expects(:fetch).returns( @fleakr_photos )

          @antique.photos.refresh!
        end
        should "add the new photos" do
          assert_equal @fleakr_photos.size, @antique.photos.size
        end
        should "create valid Photos" do
          assert @antique.photos.all?(&:valid?)
        end
        should "remove the old photos" do
          assert_not_equal @old_photos, @antique.photos
        end
      end
    end
  end

end
