Sham.define do
  sku do
    # pre = Array.new(3) { (rand(122-97) + 97).chr }.join
    # sku_frag = rand(1000)
    # suf = ['A','B','C',nil]
    # suf = suf[rand(suf.size)]
    # "#{pre}-#{sku_frag}#{suf}"
    "TEST-101"
  end
  string { (0...8).map{65.+(rand(25)).chr}.join }
  title { Faker::Company.catch_phrase }
  dimension { rand(100) + 100 }
  decimal { ((rand(100) * rand(10).to_f) / 100) + 1 }
  email { Faker::Internet.email }

  photo_size { %w{square thumbnail small medium large}.fetch(rand(3)) }
  flickr_url { |index| "http://farm#{rand(5)}.static.flickr.com/#{index}/#{rand}_abc123_%SIZE%.jpg" }
  flickr_page { "http://www.flickr.com/photos/#{rand}@N00/#{rand}/sizes/%SIZE%/" }
end

Antique.blueprint do
  sku { Sham.sku }
  name { Faker::Lorem.words(2).join(' ') }
  description { Faker::Lorem.paragraphs(2).join(' ') + " *bolded foo*" }
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

EbayAuction.blueprint do
  antique { Antique.make_unsaved }
  title { Sham.title }
  description { Faker::Lorem.paragraphs(2).join(' ') }
  start_price { Sham.decimal }
  current_price { start_price }
  shipping_price { Sham.decimal }
  item_number { Sham.string }
  length { 7 }
  start_time { 15.minutes.from_now }
end

AdminUser.blueprint do
  email { 'admin@example.com' }
  password { 'password' }
end