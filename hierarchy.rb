class Hierarchy
  def initialize(object)
    @object = object
  end

  def generate
    if @object.respond_to?(:name)
      orig_class = constantize(@object.name)
    else
      orig_class = @object.class
    end

    padding = 0
    puts '•'

    begin
      char = orig_class.superclass.nil? ? "└" : "├"
      puts "#{char}#{'─' * padding}─ #{orig_class.to_s}"

      padding += 2
    end  while orig_class = orig_class.superclass

    puts
  end

  private

  def constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?
    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end
end

if $0 == __FILE__
  Hierarchy.new(3).generate
  Hierarchy.new(Hierarchy.new(3)).generate
  Hierarchy.new(String).generate
  Hierarchy.new('test').generate
  Hierarchy.new(nil).generate
end
