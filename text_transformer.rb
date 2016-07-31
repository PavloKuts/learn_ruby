class TextTransformer
  def initialize(transformations)
    @transformations = transformations
  end

  def transform(str)
    result = str.respond_to?(:to_s) ? str.to_s : nil
    raise ArgumentError.new('ERROR! Stringish thing expected!') unless result

    @transformations.each do |transformation|
      result = transformation.call(result) if transformation.respond_to?(:call)
    end

    result
  end
end

class Student
  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end
end

if __FILE__ == $0
  transformations = [
    :test,
    -> (text) { text.upcase },
    -> (text) { text.reverse },
    nil
  ]

  conveyor = TextTransformer.new(transformations)

  puts conveyor.transform('Hello world')
  puts conveyor.transform('test test test')
  puts conveyor.transform(:test)
  puts conveyor.transform(Student.new('John Houston'))
end
