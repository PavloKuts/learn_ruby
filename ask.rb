def ask(*questions)
  return unless questions.respond_to? :to_a
  questions = questions.to_a
  results = []

  questions.each do |q|
    if q[:question]
      print "#{q[:question]}: "
      answer = gets
    end

    if q[:callback] && q[:callback].respond_to?(:call)
      results << q[:callback].call(answer)
    else
      results << answer
    end
  end

  return *results
end

data = ask({
  question: 'Enter your name',
  callback: -> (name) { name.strip }
},
{
  question: 'Enter your age',
  callback: -> (age) { age.to_i }
},
{

}).compact

puts data.inspect
