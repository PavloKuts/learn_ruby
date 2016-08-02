require 'british'
require 'testrocket'
require 'fileutils'
require 'letters'

class Newspaper
  include British::Initialisable

  PHONE_PATTERN = /(\+?(?:\d\d)?\s?\(?\d{3}\)?\s?\d{3}(?:\-|\s)?\d{2}(?:\-|\s)?\d{2})/

  def initialise(newspaper_path, words_list = [])
    @newspaper = File.read(newspaper_path)
      .lines
      .reject {|l| l.strip.empty?}
      .map {|l| l.strip}

    @words_list = words_list.to_set
  end

  def numbers_list
    numbers_list = []

    @newspaper.each do |ad|
      numbers_list << {
        number: parse_phone(ad),
        words: contains_word?(ad)
      }
    end

    numbers_list.reject! do |numbers|
      numbers[:number].nil? && numbers[:words].nil?
    end

    numbers_list
  end

  private

  def parse_phone(line)
    line.scan(PHONE_PATTERN)[0]
  end

  def contains_word?(line)
    line_words = line.scan(/(?:\b)(\p{L}{3,}?)(?:\b)/)
      .map {|w| w[0]}
      .to_set

    words = @words_list.intersection(line_words).to_a
    words.empty? ? nil : words
  end
end

if $0 == __FILE__
  begin

    !->{'Newspaper must return phones list'}
    +->{
      newspaper_path = './test/fixtures/newspaper.txt'
      good_words = ['ремонт', 'хороший']
      numbers_list = Newspaper.new(newspaper_path, good_words).numbers_list
      numbers_list[1][:number][0] == '+38(067)710-59-07'
    }

  rescue Errno::ENOENT => e
    puts "No such file: #{newspaper_path}"
  end
end
