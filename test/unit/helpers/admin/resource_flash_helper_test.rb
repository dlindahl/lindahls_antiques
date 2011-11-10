require File.dirname(__FILE__) + '/../../../test_helper'

class Admin::QuotesHelperTest < ActionView::TestCase
  tests Admin::ResourceFlashHelper

  context "An invalid resource" do
    subject { Antique.new }
    setup { resource_error_for(subject) }
    before_should "render the error partial" do
      self.expects(:render_to_string).with(:partial => "admin/resource_error", :resource => subject).returns("<span>foo</span>")
    end
  end

end
