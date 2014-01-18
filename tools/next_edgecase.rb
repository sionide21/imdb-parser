#! /usr/bin/env ruby
require 'imdb/parser'

# USAGE: ruby -I lib tools/next_edgecase.rb /path/to/actors.list

begin
  IMDB::Parser::Parser.new(File.open(ARGV[0], 'rb')).each do |a|
    a.roles
  end
rescue IMDB::Parser::ParseError => e
  puts %{
it "handles " do
  expect { parse "#{e}" }.not_to raise_error
end
  }.strip
end
