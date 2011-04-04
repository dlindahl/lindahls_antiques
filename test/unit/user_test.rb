require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should have_db_column(:email)
  should have_db_column(:admin)

  subject { User.make_unsaved }

  should "respond to admin?" do
    assert_equal false, subject.admin?
  end

  context "A User that is an admin" do
    subject { User.make_unsaved(:admin => true) }
    should "be an admin" do
      assert subject.admin?
    end
  end

end
