# Lambda creation and calling
add = -> (x, y) { x + y }
puts add.call(2, 3)
puts add[2 ,3]
puts add.(2, 3)

puts add.class

# Closure demo
def plus_plus
  val = 1
  -> { val += 1 }
end

pp = plus_plus
puts pp.call # 2
puts pp.call # 3
puts pp.call # 4


# Lambda generating method
# + closure demo
def n_times(thing)
  -> (n) { thing * n }
end

p1 = n_times(10)
puts p1.call(3)

p2 = n_times("Test")
puts p2.call(5)


# Block shadowing
z = 2
n = 5

[1, 2, 3].each do |n|
  puts z * n
end


# Closure demo
hello = 'test'
p = -> { puts hello }

def test(p)
  hello = 'Hello world'
  p.call
end

test(p)


# Yield scope demo
class Test
  attr_reader :name

  def initialize
    @name = 'Jake'
  end

  def test
    yield(self)
  end
end

t = Test.new
t.test do |n|
  puts n.name
end


# Block as file.close automation
class MyCoolFile
  def open(path, mode)
    f = File.open(path, mode)
    yield(f)
    f.close
  end
end

MyCoolFile.new.open('sdfsdf', 'a+') do |f|
  f.puts('sdfsdfds')
  f.puts('abc')
  f.puts('123')
end

class SuperClass
  def config
    @config = {}
    yield(self)
  end

  def set(param, value)
    @config[param] = value
  end

  def execute
    puts @config.inspect
  end
end

c = SuperClass.new

c.config do |settings|
  settings.set :test, true
  settings.set :ip, '192.168.0.1'
  settings.set :port, 80
end

c.execute
