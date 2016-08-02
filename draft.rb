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
