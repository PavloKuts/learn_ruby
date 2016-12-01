require 'json'
require 'fileutils'
require 'digest'

class AdsFileCache
  CACHE_PATH = "#{Dir.home}/.ad_crawler_cache"

  def initialize
    @ads = Hash.new(nil)

    FileUtils.touch CACHE_PATH

    File.open(CACHE_PATH, 'r').each_line do |l|
      ad = JSON.parse(l, {symbolize_names: true})
      @ads[ad.keys[0]] = ad.values[0]
    end
  end

  def add(ad_url, ad)
    return unless ad

    url_hash = hash(ad_url)

    return if @ads[url_hash]

    @ads[url_hash] = ad

    File.open(CACHE_PATH, 'a') { |f| f.puts({url_hash => ad}.to_json) }
  end

  def get(ad_url)
    @ads[hash(ad_url)]
  end

  private

  def hash(ad_url)
    Digest::MD5.new.update(ad_url).hexdigest.to_sym
  end
end

if __FILE__ == $0
  require 'letters'
  cache = AdsFileCache.new
  cache.add('http://example.com', {hello: 'world'})
  cache.get('http://example.com').o

  cache = AdsFileCache.new
  cache.get('http://example.com').o
end
