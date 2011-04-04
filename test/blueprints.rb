Sham.define do
  email { Faker::Internet.email }
end

User.blueprint do
  email { Sham.email }
end