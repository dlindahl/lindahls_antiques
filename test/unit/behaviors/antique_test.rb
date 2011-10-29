require File.dirname(__FILE__) + '/../../test_helper'

class BehaviorsAntiqueTest < ActiveSupport::TestCase
  subject do
    mock('antique').extend(Behaviors::Antique)
  end

  should "create a Flickr tag from its SKU" do
    @antique = subject
    @antique.stubs(:sku).returns('A-123B')

    assert_equal "a123b", @antique.sku_as_tag
  end

  should "report its dimensions in a human readable way" do
    @antique = subject
    @antique.stubs(:width).returns(1)
    @antique.stubs(:height).returns(2)
    @antique.stubs(:depth).returns(3)

    assert_equal "1w x 2h x 3d", @antique.dimensions
  end

  context "with Photos" do
    should "return a Flickr thumbnail" do
      flickr_photos = mock('photos', :square => %w{photo1 photo2} )

      @antique = subject
      @antique.stubs(:thumbnail?).returns(true)
      @antique.stubs(:photos).returns( flickr_photos )

      assert_equal 'photo1', @antique.thumbnail
    end
  end
  context "without Photos" do
    should "return nil" do
      @antique = subject
      @antique.stubs(:thumbnail?).returns(false)

      assert_nil @antique.thumbnail
    end
  end

end
