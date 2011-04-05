#!/usr/bin/ruby

# Dependencies:
# - google-search

require 'uri'
require 'rubygems'
require 'google-search'

#====================================
def print_usage
print <<TEXT
  Checks ranking of domain for a single google search term
  
  usage: #{$0} [domain] [keyword]
TEXT
exit
end

print_usage if ARGV.count != 2
#====================================
def find_item uri, query
  search = Google::Search::Web.new do |search|
    search.query = query
    search.size = :large
    search.each_response { print '.'; $stdout.flush }
  end
  search.find { |item| item.uri =~ uri }
end
#====================================

domain = ARGV[0]#URI.parse( ARGV[0] ).host
keyword = ARGV[1].downcase.gsub(/[^a-z\d\- ]/,'')

puts "Checking rank for #{domain} on keyword '#{keyword}':\t"

print "%-35s " % keyword
if item = find_item(Regexp.compile(domain), keyword)
  puts " #%d" % (item.index + 1)
else
  puts " Not found"
end


