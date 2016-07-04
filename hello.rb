class Hello
  GREETING = 'Hello world'
  PI = 3.14

  # Class (static) method example
  def self.hello
    puts GREETING
    puts "And BTW Pi is still #{PI}"
  end

  # Uncomment to see warning
  #PI = 9.8
end

Hello.hello
