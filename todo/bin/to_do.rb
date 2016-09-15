#! /usr/bin/env ruby

require 'English'
require 'letters'
require 'colorize'
require_relative '../lib/to_do_list'

class ToDoApp

  BYE_TEXT = 'Bye-bye! Thank you for using this app!'

  STRIP_LAMBDA = -> (str) { str.strip }
  INTEGER_LAMBDA = -> (str) { str.to_i }

  VALIDATORS = {
    task_text: -> (task) { task && !task.empty? },
    task_priority: -> (priority) { priority && /^[0-9]+$/.match(priority.to_s) && priority >= 0 && priority <= 100 },
    task_number: -> (number) { number && /^[0-9]+$/.match(number.to_s) && number >= 1 },
    task_count: -> (number, task_count) { number <= task_count }
  }

  VALIDATION_ERRORS = {
    task_text_error: 'Task text can\'t be empty!',
    task_priority_error: 'Priority should be a number between 0 and 100',
    task_number_error: 'Task number should be a number > 0',
    task_count_error: 'There is no task with such a number!'
  }

  def initialize
    ToDoList.new.transaction do |to_do|
      @to_do_list = to_do

      @interactive = $ARGV.include?('-i')
      run
    end
  end

  private

  def run
    begin
      if @interactive
        command = ask({
          question: 'Enter command',
          callback: STRIP_LAMBDA
        })[0]
      else
        command = args(STRIP_LAMBDA)[0]
      end

      case command
      when 'exit', 'e', 'q'
        puts
        puts
        puts 'All your edits were saved!'
        puts BYE_TEXT
        break
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
      when 'clear'
        clear
      when 'reopen'
        done(false)
      when 'uniq', 'u'
        uniq
      else
        command_not_found(command)
      end

      puts
    end while @interactive
  end

  def args(*callbacks)
    return unless callbacks.respond_to?(:to_a)
    callbacks = callbacks.to_a
    results = []

    $ARGV.each_with_index do |arg, i|
      if callbacks[i] && callbacks[i].respond_to?(:call)
        results << callbacks[i].call(arg)
      else
        results << nil
      end
    end

    return *(results.compact)
  end

  def ask(*questions)
    return unless questions.respond_to? :to_a
    questions = questions.to_a
    results = []

    questions.each do |q|
      if q[:question]
        print "#{q[:question]}: "
        answer = $stdin.gets
      end

      if q[:callback] && q[:callback].respond_to?(:call)
        results << q[:callback].call(answer)
      else
        results << answer
      end
    end

    return *results
  end

  def valid?(type, *data)
    VALIDATORS[type].call(*data)
  end

  def add
    if @interactive
      task, priority = ask({
        question: 'Enter task',
        callback: STRIP_LAMBDA
      },
      {
        question: 'Enter priority (0-100 or ⏎ )',
        callback: INTEGER_LAMBDA
      })
    else
      task, priority = args(
        nil,
        STRIP_LAMBDA,
        INTEGER_LAMBDA
      )
    end

    error(VALIDATION_ERRORS[:task_text_error]) unless valid?(:task_text, task)
    error(VALIDATION_ERRORS[:task_priority_error]) if priority && !valid?(:task_priority, priority)

    @to_do_list.add(task, priority)
  end

  def delete
    if @interactive
      print_list
      puts

      task_number = ask({
        question: 'Enter task number',
        callback: INTEGER_LAMBDA
      })[0]
    else
      task_number = args(
        nil,
        INTEGER_LAMBDA
      )[0]
    end

    error(VALIDATION_ERRORS[:task_number_error]) unless valid?(:task_number, task_number)
    error(VALIDATION_ERRORS[:task_count_error]) unless valid?(:task_count, task_number, @to_do_list.tasks.count)

    @to_do_list.delete!(task_number)
  end

  def print_list
    title = ' To Do List '
    padding = 20

    puts
    puts
    puts "#{'=' * padding}#{title}#{'=' * padding}".yellow

    @to_do_list.tasks.each_with_index do |task, index|
      done = task[:done] ? '✔'.green : ''
      text = task[:done] ? task[:text].green : task[:text]
      puts "#{index + 1}: #{text} #{done}"
    end

    puts ("=" * (title.length + (padding * 2))).yellow
  end

  def priority
    if @interactive
      print_list
      puts

      task_number, new_priority = ask({
        question: 'Enter task number',
        callback: INTEGER_LAMBDA
      },
      {
        question: 'Enter new priority (0-100 or ⏎ )',
        callback: INTEGER_LAMBDA
      })
    else
      task_number, new_priority = args(
        nil,
        INTEGER_LAMBDA,
        INTEGER_LAMBDA
      )
    end

    error(VALIDATION_ERRORS[:task_number_error]) unless valid?(:task_number, task_number)
    error(VALIDATION_ERRORS[:task_count_error]) unless valid?(:task_count, task_number, @to_do_list.tasks.count)
    error(VALIDATION_ERRORS[:task_priority_error]) if new_priority && !valid?(:task_priority, new_priority)

    @to_do_list.set_priority(task_number, new_priority)
  end

  def done(status = true)
    if @interactive
      print_list
      puts

      task_number = ask({
        question: 'Enter task number',
        callback: INTEGER_LAMBDA
      })[0]
    else
      task_number = args(
        nil,
        INTEGER_LAMBDA
      )[0]
    end

    error(VALIDATION_ERRORS[:task_number_error]) unless valid?(:task_number, task_number)
    error(VALIDATION_ERRORS[:task_count_error]) unless valid?(:task_count, task_number, @to_do_list.tasks.count)
    @to_do_list.done(task_number, status)
  end

  def clear
    @to_do_list.clear!
  end

  def uniq
    @to_do_list.uniq!
  end

  def help
    print <<-EOT

     Commands available (-i for interactive mode):

     * add (a) - add a new task
     * done - mark task as done
     * clear - clear completed tasks
     * reopen - mark task as undone
     * delete (d) - delete task
     * priority (s) - set new priority
     * print (p) - print the list
     * exit (q, e) - quit the programm
     * uniq (u) - delete duplicates
     * help (h) - show this help
     * ^C - to cancel all the operations
    EOT
  end

  def error(message)
    puts
    puts message.red

    if !@interactive
      @to_do_list.save
      exit!
    end
  end

  def command_not_found(command)
    if !@interactive && !command
      puts "Use the app in interactive mode or enter command!".red
      help
    else
      puts "Command not found: #{command}".red
    end
  end
end

trap(:INT) do
  exit
end

begin
  ToDoApp.new
rescue SystemExit
  puts
  puts
  puts 'All you edits were canceled!'.yellow
  puts ToDoApp::BYE_TEXT
end
