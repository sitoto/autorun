#encoding: UTF-8
require 'mongoid'
require 'nokogiri'
require 'open-uri'
Dir.glob("#{File.dirname(__FILE__)}/app/models/*.rb") do |lib|
  require lib
end
ENV['MONGOID_ENV'] = 'localcar'
Mongoid.load!("config/mongoid.yml")

def update_hot
    Part.all.each do |p|
      puts str = p.comment_info
      if str.nil?
        hot = 0
      else
        hot = str.scan(/\d+/)[0] || 0
      end
      p.update_attribute(:hot, hot)
    end
end
puts "Start- #{Time.now}"
update_hot
puts "End-#{Time.now}"
