require 'net/http'
require 'json'
require 'nokogiri'

class PhoneCrawler

  PHONE_ID_PATTERN = %r{(?<=\'id\'\:\')(.*?)(?=\')}i

  def self.get_phones(olx_url)
    response = Net::HTTP.get(URI(olx_url.split('#')[0]))
    phones = []

    link_phone = Nokogiri::HTML(response).try(:css, '.link-phone')

    return phones if link_phone.empty?

    phone_id = link_phone&.attribute('class')
                        &.value
                        &.match(PHONE_ID_PATTERN).to_a.fetch(1, nil)

    return phones unless phone_id

    phone_link = "https://www.olx.ua/ajax/misc/contact/phone/#{phone_id}/"

    response = Net::HTTP.get(URI(phone_link))
    data = JSON.parse(response, {symbolize_names: true})[:value]

    if data.include?('span')
      Nokogiri::HTML(data).css('.block').each {|phone| phones << phone.text}
    else
      phones << data
    end

    phones
  end
end
