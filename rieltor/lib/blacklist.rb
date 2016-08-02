require 'british'

class BlackList
  include British::Initialisable

  def initialise
  end

  def include?(phone)
    # @TODO Returns boolean if phone is in the black list
  end
end

def hello
  'tex'
end

if $0 === __FILE__
end
