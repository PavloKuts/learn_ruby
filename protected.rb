class Num
  def initialize(n)
    @value = n
  end

  def ===(other_number)
    @value.===(other_number.value)
  end

  protected

  def value
    @value
  end
end

num1 = Num.new(3)
num2 = Num.new(3)

puts num1 === num2 ? 'LOGIC!' : 'MAGIC!'
