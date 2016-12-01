class Greeting
  def good_morning
    puts 'Good morning!'
  end

  def method_missing(name, *args)
    # puts name.inspect
    puts 'WE ARE HERE!'
  end
end

class Hello < Greeting
  def method_missing(name, *args)
    puts name.inspect
    # NEVER DO THIS:
    # name = 123
    super
  end
end

hello = Hello.new
hello.good_morning
hello.good_day
