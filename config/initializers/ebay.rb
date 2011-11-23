Ebay::Api.configure do |ebay|
  YAML.load(ERB.new(File.read("#{Rails.root}/config/ebay.yml")).result)[Rails.env].each do |key, value|
    ebay.send("#{key}=", value)
  end
end