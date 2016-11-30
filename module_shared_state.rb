require 'letters'

# BAD IDEA! REMEMBER ABOUT GC!
# When object deleted State stays the same
module Hello
  State = {}

  def state=(val)
    State[object_id] = val
  end

  def state
    State[object_id]
  end

  def debug_state
    State
  end
end

class Test
  include Hello
end

t1 = Test.new
t1.state = 'State of T1'

t2 = Test.new
t2.state = 'State of T2'

t1.state.o
t2.state.o

t1.debug_state.o
