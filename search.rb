require "faraday"
require "curb"
#require "thread"
#require "socksify"
#require 'socksify/http'

def success? arg
  if [200].include? arg.status
    return true
  else
    return false
  end
end

puts "URL?"
url = gets.chomp
  if ! url.end_with?('/')
    url << '/'
  end
  unless url[/\Ahttp:\/\//] || url[/\Ahttps:\/\//]
    url = "http://#{url}"
  end
#puts "Threads?"
#threads = gets.chomp.to_i
#puts "tor? [true/false]"
#tor = gets.chomp

conn = Faraday.new(:url => url) do |faraday|
  faraday.request  :url_encoded             # form-encode POST params
  faraday.response :logger                  # logs results to STDOUT
  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  #faraday.adapter  :em_http                 # make requests with http
  faraday.headers[:useragent] = "Mozilla/4.0" #to make the request maybe not get blocked
#  if tor == "true"                          # put requests through socks4 if desired
#    faraday.proxy "http://localhost:9150"
#  end
end


puts "Starting Scans"
File.foreach("shellsdir.txt").with_index do |line|
      res = "#{url}#{line}"
      line = line.chomp
      conn.get "#{line}"
      puts conn.response
if success? response
  File.open("results.txt", 'a') do |result|
    result.puts res
  end
end
end