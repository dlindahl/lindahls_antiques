ActiveAdmin.register AdminUser do

  index do
    column :email
    column "Signed In?" do |admin_user|
      if admin_user.current_sign_in_at
        "Yes. Signed in #{time_ago_in_words(admin_user.current_sign_in_at)} ago from #{admin_user.current_sign_in_ip}"
      else
        "No"
      end
    end
    column "Last Seen" do |admin_user|
      time_ago_in_words(admin_user.last_sign_in_at) + " ago"
    end
    column :last_sign_in_ip
    default_actions
  end

end
