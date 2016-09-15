#! /usr/bin/env ruby

require 'English'

def args(*callbacks)
  return unless callbacks.respond_to?(:to_a)
  callbacks = callbacks.to_a
  results = []

  $ARGV.each_with_index do |arg, i|
    if callbacks[i] && callbacks[i].respond_to?(:call)
      results << callbacks[i].call(arg)
    else
      results << nil
    end
  end

  return *results.compact
end

name, age = args(
  nil,
  -> (arg) { arg.strip.upcase },
  -> (arg) { arg.to_i }
)

puts name.inspect
puts age.inspect
