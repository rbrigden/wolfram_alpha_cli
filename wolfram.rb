#!/usr/bin/env ruby
require 'readline'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'colorize'

def get_input
  Readline.readline "wolfram>> ", true
end

def get_result(query)
  uri = URI.encode("http://api.wolframalpha.com/v2/query?input=#{query}&appid=#{File.open('.wolfram_key').read}")
  response = Nokogiri::XML(open(uri))
  timeout = response.xpath("//queryresult").attribute("parsetimedout").value
  success = response.xpath("//queryresult").attribute("success").value
  puts ""
  if success == "true" && timeout == "false"
    response.xpath("//pod").each do |pod|
      print "#{pod.attribute("title").to_s}:".underline
      print " #{pod.xpath("//subpod//plaintext").text.to_s}".cyan
      puts ""
    end
  end
  puts ""

  #puts "Result: #{response.xpath("//plaintext").first.text}"
  return true
end

loop do
  input = get_input.to_s
  case input
    when "exit"
      break
    else
      finished = get_result(input)
      unless finished
        sleep 1
        print "."
      end
  end
end
