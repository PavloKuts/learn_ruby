require 'sqlite3'
require_relative '../flat_search'

require_relative "#{FlatSearch::PROJECT_ROOT}/db/migrations/db"

class AdsSQLiteCache
  CACHE_DEFAULT_PATH = "#{FlatSearch::PROJECT_ROOT}/db/cache.sqlite"
  CACHE_DEFAULT_LIFETIME = 1209600 # 24*60*60*14

  def initialize(cache_path = CACHE_DEFAULT_PATH, cache_expiration = CACHE_DEFAULT_LIFETIME)
    DbMigation.execute unless File.exists? cache_path
    @db = SQLite3::Database.new cache_path
    @db.results_as_hash = true

    @cache_expiration = cache_expiration
  end

  def add(ad_url, ad)
    return unless ad

    @db.execute("INSERT INTO ads(url, text) VALUES (?, ?)", [ad_url, ad[:ad_text]])
    ad_id = @db.last_insert_row_id

    return if ad_id === 0

    phones_ids = []
    ad[:ad_phones].each do |phone|
      begin
        @db.execute("INSERT INTO phones(phone) VALUES (?)", phone)
        phones_ids << @db.last_insert_row_id
      rescue SQLite3::ConstraintException => e
        phones_ids << 0 if e.message =~ /UNIQUE/
      end
    end

    phones_ids.each_with_index do |phone_id, index|
      phone_id = @db.execute("SELECT id FROM phones WHERE phone = ?", ad[:ad_phones][index])[0]['id'] if phone_id === 0
      @db.execute "INSERT INTO ads_phones(ad_id, phone_id) VALUES (?, ?)", [ad_id, phone_id]
    end

  rescue SQLite3::ConstraintException => e
    raise e unless e.message =~ /UNIQUE/
  end

  def get(ad_url)
    db_ad = @db.execute 'SELECT a.id, a.text, a.date, p.phone
                         FROM ads AS a
                         INNER JOIN ads_phones AS ap
                         ON a.id = ap.ad_id AND a.url = ?
                         INNER JOIN phones AS p
                         ON p.id = ap.phone_id', ad_url

    return if db_ad.empty?

    ad_date = Date.parse(db_ad[0]['date']).to_time.to_i
    now_date = DateTime.now.to_date.to_time.to_i
    dates_diff = now_date - ad_date

    if dates_diff >= @cache_expiration
      @db.execute 'DELETE FROM ads WHERE id = ?', db_ad[0]['id']
      return
    end

    phones = []

    db_ad.each do |ad|
      phones << ad['phone']
    end

    {
      ad_text: db_ad[0]['text'],
      ad_phones: phones
    }
  end
end

if __FILE__ == $0
  require 'letters'
  cache = AdsSQLiteCache.new
  cache.add('http://example.com', {text: 'world', phones: ['380972134567', '0936543452']})
  cache.add('http://example.com/bike', {text: 'hello', phones: ['380972134567']})
  cache.add('http://example.com/bike', {text: 'ERROR', phones: ['380972134567']})
  cache.add('http://example.com/tv', {text: 'TV for sell', phones: ['0936543452']})

  cache.get('http://example.com').o
  #
  # cache = AdsFileCache.new
  # cache.get('http://example.com').o
end
