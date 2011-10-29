require 'ostruct'
require File.dirname(__FILE__) + '/../../test_helper'

class InterrogativesAntiqueTest < ActiveSupport::TestCase
  subject do
    mock('antique').extend(Interrogatives::Antique)
  end

  context "with a thumbnail" do
    should "indicate as such" do
      @antique = subject
      @antique.stubs(:photos).returns([1])

      assert @antique.thumbnail?
    end
  end
  context "without a thumbnail" do
    should "indicate as such" do
      @antique = subject
      @antique.stubs(:photos).returns([])

      assert_equal false, @antique.thumbnail?
    end
  end

  context "that is under auction" do
    should "indicate as such" do
      @antique = subject
      @antique.stubs(:ebay_auctions).returns([ OpenStruct.new(:active? => false), OpenStruct.new(:active? => true) ])

      assert @antique.under_auction?
    end
  end
  context "that is NOT under auction" do
    should "indicate as such" do
      @antique = subject
      @antique.stubs(:ebay_auctions).returns([ OpenStruct.new(:active? => false) ])

      assert_nil @antique.under_auction?
    end
  end
end