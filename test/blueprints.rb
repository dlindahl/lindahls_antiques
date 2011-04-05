Sham.define do
  sku do
    pre = Array.new(3) { (rand(122-97) + 97).chr }.join
    sku_frag = rand(1000)
    suf = ['A','B','C',nil].rand
    "#{pre}-#{sku_frag}#{suf}"
  end
  email { Faker::Internet.email }
  decimal { ((rand(100) * rand(10).to_f) / 100) + 1 }
end

User.blueprint do
  email { Sham.email }
end

Antique.blueprint do
  sku { Sham.sku }
  name { Faker::Lorem.words(2) }
  description { Faker::Lorem.paragraphs(2) }
  width { Sham.decimal }
  height { Sham.decimal }
  depth { Sham.decimal }
  weight { Sham.decimal }
end