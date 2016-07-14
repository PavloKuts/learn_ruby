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
        ToDoApp.quit
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
    puts
    puts
    puts "#{'='*20} To Do List #{'='*20}"
    @to_do_list.print
    puts "="*52
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

  def help
    print <<-EOT

     Commands available:

     * add (a) - add a new task
     * delete (d) - delete task
     * priority (s) - set new priority
     * print (p) - print the list
     * exit (q, e) - quit the programm
     * help (h) - show this help
    EOT
  end

  def error(command)
    puts "Command not found: #{command}"
  end

  def self.quit
    puts
    puts 'Bye-bye! Thank you for using this app!'
    exit
  end

  trap(:INT) do
    ToDoApp.quit
  end
end

ToDoApp.new
