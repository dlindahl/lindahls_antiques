require File.expand_path( File.dirname(__FILE__) + '/../test_helper' )

class PaymentTest < ActiveSupport::TestCase

  should have_db_column(:paymentable_id)
  should have_db_column(:paymentable_type)
  should have_db_column(:type)
  should have_db_column(:reference_number)
  should have_db_column(:description)
  should have_db_column(:amount)

  should belong_to(:paymentable)

  should validate_numericality_of(:amount)

  should_not allow_value(nil).for(:amount)
  should_not allow_value('').for(:amount)

end