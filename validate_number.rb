class ValidateNumber
  def self.validate_number(number)
    /^([ ()+]?\d[-()]?){10,12}?$/ =~ number
  end
end

if $0 === __FILE__
puts ValidateNumber.validate_number('+380935116132')
puts ValidateNumber.validate_number('+38(093)5116132')
puts ValidateNumber.validate_number('+38(093)511-61-32')
puts ValidateNumber.validate_number('+38093511-61-32')
puts ValidateNumber.validate_number('(093)511-61-32')
puts ValidateNumber.validate_number('(093)5116132')
puts ValidateNumber.validate_number('(093) 5116132')
puts ValidateNumber.validate_number('(093) 511 61 32')
puts
puts ValidateNumber.validate_number('+380935064767_')
end
