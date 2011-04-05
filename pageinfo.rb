#!/usr/bin/ruby

# Dependencies:
# - googlepagerank
# - w3c_validators
#

require 'uri'
require 'net/http'
require 'rubygems'
require 'w3c_validators'
require "googlepagerank"

#====================================
def print_usage
print <<TEXT
  Prints information about given url
  
  usage: #{$0} [URL]
TEXT
exit
end

print_usage if ARGV.count != 1
#====================================

url = URI.parse( ARGV[0] )
url = url + '/' if url.path == ""
req = Net::HTTP::Get.new(url.path)
res = Net::HTTP.start(url.host, url.port) {|http|
  http.request(req)
}
body = res.body

puts "# SEO information for: #{url} #\n"

# pagerank
print "Google-PageRank:\t\t"
puts GooglePageRank.get(url.to_s)

# code:content ratio
count_all = body.gsub(/\s/,'').size
count_content = body.gsub(/\s/,'').downcase.match(/<body.*>(.*)<\/body>/m)[0].gsub(/<\/?[^>]*>/,'').size
code_content_ratio = count_content.to_f / count_all
puts "Code:Content-Ratio:\t\t%.4f" % code_content_ratio

# valid HTML
print "Check HTML:\t\t\t"
include W3CValidators
@validator = MarkupValidator.new
results = @validator.validate_uri( url )
if results.errors.length > 0
  puts "#{results.errors.length} error(s)"
else
  puts "valid"
end




