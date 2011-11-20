require File.dirname(__FILE__) + '/../../../test_helper'

class Admin::Photos::PhotosTest < ActiveSupport::TestCase
  Admin::Photos::Photos.send(:include, ActionView::Helpers::TextHelper)
  Admin::Photos::Photos.send(:include, ActionView::Helpers::UrlHelper)

  subject do
    Admin::Photos::Photos.new.tap do |mock|
      antique = mock('MockResource')
      mock.stubs(:antique).returns( antique )

      mock.stubs(:photos).returns( %w{1 2 3 4 5} )
    end
  end

  should "generate a link to refresh photos" do
    subject.expects(:refresh_admin_antique_photos_path).returns('/foo')

    assert_equal '<a href="/foo">Refresh?</a>', subject.refresh_link
  end

  should "generate a pluralized count of photos" do
    assert_equal "5 photos", subject.humanized_photo_count
  end

end
