Sham.define do
  sku do
    pre = Array.new(3) { (rand(122-97) + 97).chr }.join
    sku_frag = rand(1000)
    suf = ['A','B','C',nil].rand
    "#{pre}-#{sku_frag}#{suf}"
  end
  title { Faker::Company.catch_phrase }
  dimension { rand(100) + 100 }
  decimal { ((rand(100) * rand(10).to_f) / 100) + 1 }
  email { Faker::Internet.email }

  photo_size { %w{square thumbnail small medium large}.fetch(rand(3)) }
  flickr_url { |index| "http://farm#{rand(5)}.static.flickr.com/#{index}/#{rand}_abc123_%SIZE%.jpg" }
  flickr_page { "http://www.flickr.com/photos/#{rand}@N00/#{rand}/sizes/%SIZE%/" }
end

User.blueprint do
  email { Sham.email }
end

Antique.blueprint do
  sku { Sham.sku }
  name { Faker::Lorem.words(2).join(' ') }
  description { Faker::Lorem.paragraphs(2) }
  width { Sham.decimal }
  height { Sham.decimal }
  depth { Sham.decimal }
  weight { Sham.decimal }
end

Photo.blueprint do
  title { Sham.title }
  size { Sham.photo_size(:unqiue => false) }
  width { Sham.dimension }
  height { Sham.dimension }
  url { Sham.flickr_url.gsub(/%SIZE%/, size[0].chr) }
  page { Sham.flickr_page.gsub(/%SIZE%/, size[0].chr) }
end