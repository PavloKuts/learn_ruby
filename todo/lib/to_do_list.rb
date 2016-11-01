require 'json'

class ToDoList

  FILENAME = "#{Dir.home}/todo.list"

  attr_reader :tasks

  def initialize(filename = FILENAME)
    @tasks = []
    load(filename)
  end

  def transaction
    yield(self)
    save
  end

  def add(text, priority = nil)
    task = create(text, priority, false)
    @tasks << task

    resort!
  end

  def delete!(task_number)
    @tasks.delete_at(task_number - 1)
  end

  def set_priority(task_number, priority)
    @tasks[task_number - 1][:priority] = priority
    resort!
  end

  def done(task_number, status = true)
    @tasks[task_number - 1][:done] = status
  end

  def save
    @file.truncate(0)

    @tasks.each do |t|
      @file.puts t.to_json
    end

    @file.close
  end

  def clear!
    @tasks.delete_if do |t|
      t[:done]
    end
  end

  def uniq!
    @tasks.uniq! {|task| task[:text].downcase}
  end

  private

  def create(text, priority, done)
    task = Hash.new(0)

    task[:text] = text
    task[:priority] = priority if priority
    task[:done] = done

    task
  end

  def load(filename)
    @file = File.open(filename, 'a+')

    while task = @file.gets
      task = JSON.parse(task, {symbolize_names: true})
      task = create(task[:text], task[:priority], task[:done])
      @tasks << task
    end
  end

  def resort!
    @tasks.sort_by! {|task| task[:priority]}
    @tasks.reverse!
  end
end

if $0 === __FILE__
  require 'letters'

  File.delete(ToDoList::FILENAME) if File.exists?(ToDoList::FILENAME)

  todo = ToDoList.new

  todo.transaction do |to_do_list|
    to_do_list.add('Hello')
    to_do_list.add('hello')
    to_do_list.add('Buy a bottle of milk')
    to_do_list.add('Write a programm', 70)

    to_do_list.done(2)
    to_do_list.done(4)

    to_do_list.tasks.o

    to_do_list.clear

    to_do_list.tasks.o

    #puts
    #puts "=="*20
    #puts

    #to_do_list.delete!(1)
    #to_do_list.set_priority(2, 100)
    #to_do_list.print

    #puts
    #puts "=="*20
    #puts

    #to_do_list.set_priority(2, 200)
    #to_do_list.done(2)
    #to_do_list.print
  end
end
