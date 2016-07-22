word = gets.strip

#var = if word == 'test'
  #'hello'
#elsif word == 'hello'
  #'world'
#elsif word == 'go'
  #'ok'
#else
  #'else'
#end

#var = case word
#when 'test'
  #'hello'
#when 'hello'
  #'world'
#when 'go'
  #'ok'
#else
  #'else'
#end

words = {'test' => 'hello', 'hello' => 'world', 'go' => 'ok'}
var = words.fetch(word, 'else')

puts var
