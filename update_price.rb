#encoding: UTF-8
require 'mongoid'
require 'nokogiri'
require 'open-uri'
Dir.glob("#{File.dirname(__FILE__)}/app/models/*.rb") do |lib|
  require lib
end
ENV['MONGOID_ENV'] = 'localcar'
Mongoid.load!("config/mongoid.yml")

def update_price
    parts = Part.where(:from_site => '易迅网')
    puts parts.length
    parts.all.each do |p|
      str = p.price
      if str.nil?
        price = 0
      else #if (str =~ /\&yen/ )# && !(str =~ /&yen;/ )
        price = str.gsub("&amp;yen", "￥")
        puts price
        p.update_attribute(:price, price)
      end
      
      #p.update_attribute(:price, price)
    end
end
puts "Start- #{Time.now}"
update_price
puts "End-#{Time.now}"
