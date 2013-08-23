#encoding: UTF-8
require 'mongoid'
require 'nokogiri'
require 'open-uri'
Dir.glob("#{File.dirname(__FILE__)}/app/models/*.rb") do |lib|
  require lib
end
ENV['MONGOID_ENV'] = 'localcar'
Mongoid.load!("config/mongoid.yml")

@parts = Part.where(:from_site => '亚马逊').asc(:updated_at)#.only(:from_site, :url).asc(:updated_at)
puts "Start- #{Time.now}"
@parts.each_with_index do |product,i|
  url = product.url
  doc = Nokogiri::HTML(open(url))
  price = doc.at_xpath('//span[@id="actualPriceValue"]/b/text()').to_s
  product.update_attribute(:price, price) if !price.blank?
  jia = Jia.new(:price => price)
  product.jias  << jia
#  product.save
#  break
end
puts "End-#{Time.now}"
