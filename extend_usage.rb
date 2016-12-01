module Hello
  def hello
    puts 'Hello'
  end
end

class TestClass
  extend Hello
end

class TestObj
  include Hello
end

class Test
end

TestClass.hello
TestObj.new.hello

t1 = Test.new
t1.extend(Hello)
t1.hello

t2 = Test.new
t2.hello
