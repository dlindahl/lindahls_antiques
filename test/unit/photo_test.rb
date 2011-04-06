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

end
