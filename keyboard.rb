class Key
  attr_reader :state
  attr_reader :name

  alias_method :to_s, :name

  def initialize(name, up_code, down_code)
    @state = :up
    @name = name
    @up_code = up_code
    @down_code = down_code
  end

  def press(time)
    down_code = "#{down.to_s} " * time
    up_code = up

    "Down code: #{down_code} - Up code: #{up_code}"
  end

  private

  def down
    @state = :down
    @down_code
  end

  def up
    @state = :up
    @up_code
  end
end

module Cat
  def meow
    'Meow'
  end
end

class DoorBell
  include Cat

  def initialize(*)
  end

  def press(time)
    sound = meow
    "#{sound} " * time
  end
end

class Keyboard
  attr_reader :keys

  def initialize
    @keys =  {
      q: Key.new(:q, 18, 18),
      w: Key.new(:w, 19, 19),
      ctrl: Key.new(:ctrl, 130, 80),
      bell: DoorBell.new(:dzzz, 69, 90)
    }.freeze
  end

  def press(key_name, time = 1)
    key_name = key_name.to_sym.downcase if key_name.respond_to?(:to_sym)

    if @keys.has_key?(key_name)
      return @keys[key_name].press(time)
    end
  end
end

keyboard = Keyboard.new
puts keyboard.press(:bell, 10)
puts keyboard.press(:q, 10)
