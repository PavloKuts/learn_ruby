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
