require 'json'
require 'nokogiri'

class AdCrawler
  PHONE_ID_PATTERN = %r{(?<=\'id\'\:\')(.*?)(?=\')}i

  def initialize(cache, http_client, logger)
    @cache = cache
    @logger = logger
    @http_client = http_client

    @pages_memoize = {}
  end

  def ads(olx_search_url, start_page = 1, finish_page = nil, &block)
    olx_search_url = @http_client.clear_url(olx_search_url)

    return unless @http_client.page_exists?(olx_search_url)

    @logger.info("Processing #{olx_search_url}...")

    ads_links = []
    ads = []

    pages_iterate(olx_search_url, start_page, finish_page) do |search_page_url|
      links_chunk = ads_links(search_page_url)
      ads_links += links_chunk if links_chunk
    end

    ads_links.map! {|l| @http_client.clear_url(l)}.uniq!

    @logger.info("Total count of parsed links: #{ads_links.count}")

    ads_count = ads_links.count

    ads_links.each do |ad_link|
      yield(ads_count) if block_given?

      ad = ad(ad_link)
      ads << ad if ad
    end

    @logger.info("Total count of parsed ads: #{ads.count}")
    ads
  end

  def ad(olx_ad_url)
    ad = @cache.get(olx_ad_url)

    if ad
      @logger.debug('Ad from cache: ' + ad.to_s)
      return ad
    end

    page_html = @http_client.get_page(olx_ad_url, @logger)

    return unless page_html

    text = ad_text(page_html)
    phones = ad_phones(page_html)

    @logger.error("#{olx_ad_url} has no phone or text!") unless text && phones

    return unless text && phones

    ad = {
      ad_text: text,
      ad_phones: phones
    }

    @logger.debug('Pocessed ad: ' + ad.to_s)

    @cache.add(olx_ad_url, ad)

    ad
  end

  def last_page_number(olx_search_url)
    return @pages_memoize[olx_search_url] if @pages_memoize[olx_search_url]

    page_html = @http_client.get_page(olx_search_url, @logger)

    return unless page_html

    last_page_number = Nokogiri::HTML(page_html).css('.pager > .item span').last.text.to_i

    @logger.info("Total pages count: #{last_page_number}")
    @pages_memoize[olx_search_url] = last_page_number

    last_page_number
  end

  private

  def ad_text(page_html)
    ad_text = Nokogiri::HTML(page_html).css('.descriptioncontent #textContent')
                            .text
                            .gsub(/\s+/, ' ')
                            .strip

    ad_title = Nokogiri::HTML(page_html).css('h1')
                            .text
                            .gsub(/\s+/, ' ')
                            .strip


    return if ad_text.empty? || ad_title.empty?

    "#{ad_title} #{ad_text}".strip
  end

  def ad_phones(page_html)
    phones = []

    link_phone = Nokogiri::HTML(page_html).css('.link-phone')

    return if link_phone.empty?

    phones_id = link_phone&.attribute('class')
                         &.value
                         &.match(PHONE_ID_PATTERN).to_a.fetch(1, nil)

    return unless phones_id

    phones_link = "https://www.olx.ua/ajax/misc/contact/phone/#{phones_id}/"

    page_html = @http_client.get_page(phones_link, @logger)

    return unless page_html

    begin
      data = JSON.parse(page_html, {symbolize_names: true})[:value]
    rescue JSON::ParserError
      @logger.error("#{phones_link} parsing error ::: '#{page_html}'")
      return
    end

    if data.include?('span')
      Nokogiri::HTML(data).css('.block').each {|phone| phones << phone.text}
    else
      phones << data
    end

    return if phones.empty?

    phones.map! { |p| clear_phone(p) }
  end

  def pages_iterate(olx_search_url, start_page, finish_page)
    olx_search_url.sub!(/&page=\d+$/, '')

    last_page_number = @last_page_number ? @last_page_number : last_page_number(olx_search_url)

    finish_page = last_page_number if !finish_page || finish_page > last_page_number

    @logger.info("Processing pages from ##{start_page} to ##{finish_page}")

    (start_page..finish_page).each do |page_number|
      @logger.info("Processing page ##{page_number} of #{finish_page}")

      if page_number > 1
        if olx_search_url =~ /\/\?/
          page_url = "#{olx_search_url}&page=#{page_number}"
        else
          page_url = "#{olx_search_url}?page=#{page_number}"
        end
      else
        page_url = olx_search_url
      end

      yield(page_url)
    end
  end

  def ads_links(olx_search_url)
    page_html = @http_client.get_page(olx_search_url, @logger)

    return unless page_html

    ads_links = []

    Nokogiri::HTML(page_html).css('.detailsLink').each do |ad_link|
      link = ad_link.attributes['href'].value unless ad_link.attributes['href'].value =~ /promoted$/

      @logger.debug('Link on page: ' + link) if link

      ads_links << link if link
    end

    ads_links_count = ads_links.count

    ads_links = ads_links.uniq

    ads_uniq_links_count = ads_links.count

    @logger.info("Page ads ::: Total: #{ads_links_count} Uniq: #{ads_uniq_links_count}")

    ads_links
  end

  def clear_phone(phone)
    phone.scan(/\d/).join
  end
end

class AdCrawlerError < Exception
end

if $0 === __FILE__
  require 'testrocket'


  # !->{'AdCrawler must return all ads'}
  # +->{

        olx_search_url = 'https://www.olx.ua/nedvizhimost/arenda-kvartir/dolgosrochnaya-arenda-kvartir/kiev/?search%5Bdistrict_id%5D=9&page=25'
        olx_search_url = 'https://www.olx.ua/nedvizhimost/arenda-kvartir/kiev/'

        ads = ad_crawler.ads(olx_search_url, 4, 4)
  #    }
end
