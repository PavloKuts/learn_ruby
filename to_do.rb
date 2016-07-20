#! /usr/bin/env ruby

require_relative './to_do_list'

class ToDoApp

  def initialize
    @to_do_list = ToDoList.new
    run
  end

  private

  def run
    while true
      print 'Enter command: '
      command = gets.strip

      case command
      when 'exit', 'e', 'q'
        exit
      when 'help', '', 'h'
        help
      when 'add', 'a'
        add
      when 'delete', 'd'
        delete
      when 'print', 'p'
        print_list
      when 'priority', 's'
        priority
      when 'done'
        done
      when 'uniq', 'u'
        uniq
      else
        error(command)
      end

      puts
    end
  end


  def add
    print 'Enter task: '
    task = gets.strip

    print 'Enter priority (0-100): '
    priority = gets.to_i

    @to_do_list.add(task, priority)
  end

  def delete
    print_list
    puts

    print 'Enter task number: '
    task_number = gets.to_i

    @to_do_list.delete!(task_number)
  end

  def print_list
    title = ' To Do List '
    padding = 20

    puts
    puts
    puts "#{'=' * padding}#{title}#{'=' * padding}"
    @to_do_list.print
    puts "=" * (title.length + (padding * 2))
  end

  def priority
   print_list
   puts

   print 'Enter task number: '
   task_number = gets.to_i

   print 'Enter priority (0-100): '
   new_priority = gets.to_i

   @to_do_list.set_priority(task_number, new_priority)
  end

  def done
   print_list
   puts

   print 'Enter task number: '
   task_number = gets.to_i

   @to_do_list.done(task_number)
  end

  def uniq
    @to_do_list.uniq!
  end

  def help
    print <<-EOT

     Commands available:

     * add (a) - add a new task
     * delete (d) - delete task
     * priority (s) - set new priority
     * print (p) - print the list
     * exit (q, e) - quit the programm
     * uniq (u) - delete duplicates
     * help (h) - show this help
    EOT
  end

  def error(command)
    puts "Command not found: #{command}"
  end

  trap(:INT) do
    exit
  end
end

begin
  ToDoApp.new
rescue SystemExit
  puts
  puts 'Bye-bye! Thank you for using this app!'
end
