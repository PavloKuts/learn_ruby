class DVDJar
  def initialize(films)
    @stack = films
  end

  def push(film)
    @stack.unshift(film)
  end

  def pop
    @stack.shift
  end

  def size
    @stack.size
  end

  def to_s
    list = ''

    @stack.each do |film|
      list += "→ #{film}\n"
    end

    list
  end
end

jar = DVDJar.new(["Matrix 1", "Matrix 2: RELOAD"])
puts jar.to_s

puts
puts "="*50
puts

jar.push("Matrix 3: HZ")
puts jar.to_s
