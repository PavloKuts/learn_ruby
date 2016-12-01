require 'letters'

class MyTime
  attr_reader :value

  def initialize(value)
    @value = value.to_i
  end

  def self.parse(string)
    minutes, seconds = string.split(':').map(&:to_i)
    new((minutes * 60) + seconds)
  end

  def minutes
    value / 60
  end

  def seconds
    value % 60
  end

  def to_s
    "#{minutes}:#{seconds}"
  end

  def coerce(other)
    [MyTime.new(other), self]
  end

  def +(other)
    if other.is_a? MyTime
      MyTime.new(value + other.value)
    elsif other.is_a? Numeric
      MyTime.new(value + other)
    else
      if other.respond_to? :coerce
        a, b = other.coerce(self)
        a + b
      else
        raise TypeError, "#{other.class} can't be coerced into MyTime"
      end
    end
  end
end

a = MyTime.parse('1:15')
b = 60

(b + a + 1 + MyTime.new(25) + MyTime.parse('0:10')).to_s.o
