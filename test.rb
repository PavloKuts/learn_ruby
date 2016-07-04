require_relative './hierarchy'
require 'English'

if $ARGV[0] === '-v'
  puts 'My version is: 0.0.1'
else
  # Global variables usage
  puts $0
  puts `ls`
  puts $ARGV.inspect

  # Child status with and without English
  puts $?.to_i
  puts $CHILD_STATUS.to_i
end

