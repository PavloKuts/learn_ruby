require 'pathname'

module FlatSearch
  PROJECT_ROOT = File.expand_path(Pathname.new(__FILE__).join('../..'))
  DEBUG = ENV['FLAT_SEARCH_DEBUG'] && !ENV['FLAT_SEARCH_DEBUG'].empty? ? ENV['FLAT_SEARCH_DEBUG'].to_i : false
  VERSION = '0.1.0'
end

require 'letters' if FlatSearch::DEBUG && FlatSearch::DEBUG == 0
require 'byebug' if FlatSearch::DEBUG && FlatSearch::DEBUG == 0
