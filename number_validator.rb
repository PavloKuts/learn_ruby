class NumberValidator
  def self.validate_number(number)
    /^\+?(\d\d)?\s?\(?\d{3}\)?\s?\d{3}(\-|\s)?\d{2}(\-|\s)?\d{2}$/ =~ number
  end
end

if $0 === __FILE__
  numbers = [
    '+380936650978',
    '+38(096)6650978',
    '+38(096)665-61-32',
    '+38096665-61-32',
    '(096)665-61-32',
    '(096)6650978',
    '(096) 6650978',
    '(096) 665 61 32',
    '+3+8+0-+9-+6+3+4-+4+2+1+2-+1',
    '+3+8+0-(9-+6(3+4)+4(2+1+2-+1',
    '+380965064767_',
    ' +380936650978',
    '+38(0987435656', # @TODO Fix this case
    '+38098)7435656' # @TODO Fix this case
  ]

  numbers.each do |number|
    puts NumberValidator.validate_number(number) ? "Number #{number} is — OK" : "Number #{number} is — WRONG"
  end
end
