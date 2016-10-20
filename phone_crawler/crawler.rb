require 'net/http'
require 'letters'

PHONE_PATTERN = /(?<!\()(\+?(?:\d\d)?\s?\(?\d{3}\)?(?:\-|\s)?\d{3}(?:\-|\s)?\d{2}(?:\-|\s)?\d{2})(?!=\))/

url = URI(ARGV[0])
response = Net::HTTP.get(url)

phones = response.scan(PHONE_PATTERN).map {|p| p[0]}

phones.each do |phone|
  puts " ☎   #{phone}"
end
