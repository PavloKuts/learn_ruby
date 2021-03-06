require 'set'
require 'testrocket'
require 'active_support/core_ext/string/multibyte'

class Newspaper
  PHONE_PATTERN = /(\+?(?:\d\d)?\s?\(?\d{3}\)?(?:\-|\s)?\d{3}(?:\-|\s)?\d{2}(?:\-|\s)?\d{2})/
  WORDS_PATTERN = /(?:\b)(\p{L}{3,}?)(?:\b)/i

  def initialize(newspaper_path, words_list = [])
    raise TypeError, "no implicit convertion of #{words_list.class} (#{words_list.inspect}) into Set" unless words_list.respond_to?(:to_set)

    @words_list = words_list.to_set

    @newspaper = File.read(newspaper_path.to_s)
      .lines
      .reject {|l| l.strip.empty?}
      .map {|l| l.strip.mb_chars.downcase.to_s}
  end

  def numbers_list
    numbers_list = []

    @newspaper.each do |ad|
      numbers_list << {
        number: parse_phone(ad),
        words: contains_words?(ad)
      }
    end

    numbers_list.reject! do |numbers|
      numbers[:number].nil? && numbers[:words].nil?
    end

    numbers_list
  end

  private

  def parse_phone(line)
    number = line.scan(PHONE_PATTERN)[0]
    number[0].strip if number
  end

  def contains_words?(line)
    line_words = line.scan(WORDS_PATTERN)
      .map {|w| w[0]}
      .to_set

    words = @words_list.intersection(line_words).to_a
    words.empty? ? nil : words
  end
end

if $0 === __FILE__
  require 'letters'

  newspaper_path = './test/fixtures/newspaper.txt'

  !->{'Newspaper must return phones list'}
  +->{
    good_words = ['ремонт', 'хороший']
    numbers_list = Newspaper.new(newspaper_path, good_words).numbers_list
    numbers_list.count == 5
  }

  !->{'Newspaper must return words'}
  +->{
    numbers = Newspaper.new(newspaper_path, ['посредник', 'маклер']).numbers_list
    good_numbers = []

    numbers.each do |n|
      good_numbers << n[:number] unless n[:words]
    end

    good_numbers === ['+38(067)710-59-07', '+380964567889', '0971681616']
  }

  +->{
    numbers = Newspaper.new(newspaper_path, ['ремонт']).numbers_list

    good_numbers = []

    numbers.each do |n|
      good_numbers << n[:number] if n[:words] && n[:number]
    end

    good_numbers === ['067-707-47-89', '+380937659867']
  }
end
