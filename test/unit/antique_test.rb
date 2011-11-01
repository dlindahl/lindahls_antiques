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

  should_not allow_value(0).for(:weight)
  should_not allow_value(0).for(:width)
  should_not allow_value(0).for(:height)
  should_not allow_value(0).for(:depth)

  should have_many(:photos)
  should have_many(:ebay_auctions)

  context "A saved Antique" do
    subject do
      VCR.use_cassette('flickr_fetch') do
        Antique.make
      end
    end
    should validate_uniqueness_of(:sku)
  end

  context "An Antique" do
    subject { Antique.make_unsaved }
    context "with photos" do
      setup do
        @antique = subject
        @antique.photos.destroy_all
        @old_photos = @antique.photos.clone
      end
      context "that are refreshed" do
        setup do
          VCR.use_cassette('flickr_fetch') do
            @antique.photos.refresh!
          end
        end
        should "fetch the new photos" do
          assert_not_equal (@old_photos.size * Photo::SIZES.size), @antique.photos.size
        end
        should "create valid Photos" do
          assert @antique.photos.all?(&:valid?)
        end
        should "remove the old photos" do
          @old_photos.each { |op| assert_equal false, @antique.photos.include?(op) }
        end
      end
    end
    context "that is saved" do
      setup do
        @antique = subject
        VCR.use_cassette('flickr_fetch') do
          subject.save
        end
      end
      before_should "automatically retrieve its photos from Flickr" do
        Photo.expects(:fetch).returns([])
      end
      should "save the photos to the database" do
        assert_equal false, @antique.photos.any?(&:new_record?)
      end
    end
  end

end
