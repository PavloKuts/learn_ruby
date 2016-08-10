require 'british'

class BlackList
  include British::Initialisable

  def initialise(black_list_path)
    @black_list_path = black_list_path
    @black_list = File.read(@black_list_path)
      .lines
      .reject {|number| number.strip.empty?}
      .map {|number| number.strip}
      .map {|number| clear_number(number) }
      .uniq
  end

  def include?(number)
    number =  clear_number(number)
    @black_list.include?(number)
  end

  def save_number(number)
    number = clear_number(number)

    File.open(@black_list_path, 'a') do |file|
      unless include?(number)
        @black_list << number
        file.puts number
      end
    end
  end

  private

  def clear_number(number)
    number.scan(/\d+/).join
  end
end

if $0 === __FILE__
  require 'letters'

  black_list_path = './test/fixtures/black_list.txt'

  bl = BlackList.new(black_list_path)
  bl.include?('+380936754321').o
  bl.include?('+38(097)456-98-25').o
end
