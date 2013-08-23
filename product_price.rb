#encoding: UTF-8
require 'mongoid'
require 'nokogiri'
require 'open-uri'
Dir.glob("#{File.dirname(__FILE__)}/app/models/*.rb") do |lib|
  require lib
end
ENV['MONGOID_ENV'] = 'localcar'
Mongoid.load!("config/mongoid.yml")
def safe_open(url, retries = 3, sleep_time = 0.42,  headers = {})
  begin  
    html = open(url).read  
  rescue StandardError,Timeout::Error, SystemCallError, Errno::ECONNREFUSED #有些异常不是标准异常  
    puts $!  
    retries -= 1  
    if retries > 0  
      sleep sleep_time and retry  
    else  
      ""
      #logger.error($!)
      #错误日志
      #TODO Logging..  
    end  
  end
end
times = 0 
@parts = Part.where(:from_site => '亚马逊').asc(:updated_at)#.only(:from_site, :url).asc(:updated_at)
puts "Start- #{Time.now}"
@parts.each_with_index do |product,i|
  url = product.url
  html_stream = safe_open(url, retries = 3, sleep_time = 0.42,  headers = {})
  next if "" == html_stream 
  doc = Nokogiri::HTML(html_stream)
  price = doc.at_xpath('//span[@id="actualPriceValue"]/b/text()').to_s
  product.update_attribute(:price, price) if !price.blank?
  jia = Jia.new(:price => price)
  product.jias  << jia
  times += 1
# product.save
  #break if i > 2
end
puts "has update #{times} items"
puts "End-#{Time.now}"
