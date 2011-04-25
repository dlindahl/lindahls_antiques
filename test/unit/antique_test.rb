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
          sized_photo = mock('sized_photo') do
            stubs(:page).returns(Sham.flickr_page)
            stubs(:url).returns(Sham.flickr_url)
            stubs(:width).returns(Sham.dimension)
            stubs(:height).returns(Sham.dimension)
          end

          @fleakr_photo = stub('fleakr_photo', Photo.make_unsaved.attributes) do
            Photo::SIZES.each do |s|
              self.stubs(s).returns(sized_photo)
            end
          end
          @fleakr_photos = [ @fleakr_photo ]
          Photo.expects(:fetch).with(@antique.sku_as_tag).returns( @fleakr_photos )
        end
        context "while Fleakr is having issues" do
          setup do
            @fleakr_photos.first.expects(:send).times(Photo::SIZES.size).raises(Exception)
          end
          should "log an error in the Rails log" do
            Rails.logger.expects(:error).times(Photo::SIZES.size)
            @antique.photos.refresh!
          end
        end
        context "with no Fleakr issues" do
          setup do
            @old_photos = @antique.photos.clone

            @antique.photos.refresh!
          end
          should "save the new photos" do
            assert_equal @fleakr_photos.size * Photo::SIZES.size, @antique.photos.size
          end
          should "create valid Photos" do
            assert @antique.photos.all?(&:valid?)
          end
          should "remove the old photos" do
            @old_photos.each { |op| assert_equal false, @antique.photos.include?(op) }
          end
        end
      end
    end
    context "that is saved" do
      should "automatically retrieve its photos from Flickr" do
        Photo.expects(:fetch).returns([])
        subject.save
      end
    end
  end

end
