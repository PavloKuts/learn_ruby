class Animal
  def talk(times)
    'RRRRRR! ' * times
  end
end

class Dog < Animal
  def talk(times)
    ('Woof! ' * times) + super
  end
end

class Cat < Animal
  def talk(times)
    speech = ('Meow! ' * times)
    times = 5 # influence super!
    speech += super
  end
end

puts Dog.new.talk(3)
puts Cat.new.talk(3)
