#!/usr/bin/ruby
#
# Dependencies:
# - nokogiri
# - open-uri
#

require 'rubygems'
require 'nokogiri'
require 'open-uri'

#====================================
def print_usage
print <<TEXT
  Searches HTML of given url for occurences of the keyword
  in semantic relevant tags.
  
  usage: #{$0} [URL] [Keyword]
TEXT
exit
end

print_usage if ARGV.count != 2
#====================================

def getOccurences(doc, keyword, selector)
  i = 0
  doc.css(selector).each do |h|
    i = i + 1 if h.content.match(/#{keyword}/mi)
  end
  i
end

keyword = ARGV[1]
doc = Nokogiri::HTML(open(ARGV[0]))

o_total, o_title, o_h, o_link, o_emstrong = 0, 0, 0, 0, 0

puts "Find tags including keyword (#{keyword}):"

o_title = getOccurences(doc, keyword, "title")
puts " - %-30s %4d times " % ["title" , o_title]

o_h = getOccurences(doc, keyword, "h1,h2,h3,h4,h5,h6")
puts " - %-30s %4d times " % ["h1,h2,h3,h4,h5,h6" , o_h]

o_link = getOccurences(doc, keyword, "a")
puts " - %-30s %4d times " % ["a" , o_link]

o_emstrong = getOccurences(doc, keyword, "strong, em")
puts " - %-30s %4d times " % ["strong, em" , o_emstrong]

o_total =  o_title + o_h + o_link + o_emstrong
puts "%-33s %4d times " % ["TOTAL" , o_total]

