require 'letters'

# BAD-BAD IDEA!
module Hello
  ELEMENTS = []
end

class Test
  include Hello

  def initialize(number)
    ELEMENTS << number
  end

  def elements
    ELEMENTS
  end
end

t1 = Test.new(1)
t1.elements.o

t2 = Test.new(2)
t2.elements.o

t3 = Test.new(3)
t3.elements.o
