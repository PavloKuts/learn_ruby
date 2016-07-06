class ToDoList
  def initialize
    @tasks = []
  end

  def add(text, priority = nil)
    task = Hash.new(0)

    task[:text] = text
    task[:priority] = priority if priority

    @tasks << task

    resort!
  end

  def print
    @tasks.each_with_index do |task, index|
      puts "#{index + 1}: #{task[:text]}"
    end
  end

  def delete!(task_number)
    @tasks.delete_at(task_number - 1)
  end

  def set_priority(task_number, priority)
    @tasks[task_number - 1][:priority] = priority
    resort!
  end

  private

  def resort!
    @tasks.sort_by! {|task| task[:priority]}
    @tasks.reverse!
  end
end

to_do_list = ToDoList.new
to_do_list.add('Hello')
to_do_list.add('Buy a bottle of milk')
to_do_list.add('Write a programm', 70)
to_do_list.print

puts
puts "=="*20
puts


to_do_list.delete!(1)
to_do_list.set_priority(2, 100)
to_do_list.print

puts
puts "=="*20
puts

to_do_list.set_priority(2, 200)
to_do_list.print
