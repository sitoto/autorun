#encoding: UTF-8
require 'mongoid'
require 'nokogiri'
require 'open-uri'
Dir.glob("#{File.dirname(__FILE__)}/app/models/*.rb") do |lib|
  require lib
end
ENV['MONGOID_ENV'] = 'localcar'
Mongoid.load!("config/mongoid.yml")

Product.all.each do |product|
  url = product.url
  doc = Nokogiri::HTML(open(url))
  price = doc.at_xpath('//span[@id="actualPriceValue"]/b/text()').to_s
  puts price
    
  product.update_attribute(:price, price)
  break
end
