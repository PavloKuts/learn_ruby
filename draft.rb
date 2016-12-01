require 'set'
class Test
  def test
    puts 'Hello'
  end

  def hello
    puts 'Test'
  end
end

class Test
  def test
    puts 'Test'
  end

  def ok
    puts 'Yes!'
  end
end

t = Test.new
t.test
t.hello
t.ok

class Tets
  def to_set
    'duck'
  end
end

def hello(a)
  a = a.to_set if a.respond_to? :to_set
  a.interception([1,2,3].to_set)
end

a = Test.new
puts hello(a).inspect
