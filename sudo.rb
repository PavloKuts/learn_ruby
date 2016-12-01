class Test
  private

  def test_me
    puts 'test'
  end

  def hello
    puts 'hello'
  end

  def method_missing(name, *args, &block)
    name = name.to_s.split('_')

    if name.count > 1 && name[0] === 'sudo'
      method_name = name[1..-1].join('_').to_sym
      self.send(method_name, *args, &block)
    else
      method_name = name.join('_').to_sym
      super(method_name, *args, &block)
    end
  end
end

Test.new.sudo_test
