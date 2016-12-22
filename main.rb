require 'csv'
require 'pry'



# The program should prompt the user for the number of questions to put in the quiz.
tries = 3
questions_for_quiz = 0
tries.times do |try|

  puts "\nyou have #{3 - try} tries left\n" if try > 0
  print "Please enter the number of questions to put in the quiz: "
  # Any integer value greater than 0 is acceptable.
  questions_for_quiz = gets.to_i

  break if questions_for_quiz.is_a? Integer and questions_for_quiz > 0

  if try >= 2 then abort "\nPlease try regenerating the quiz with an integer greater than zero." end
  puts "\nWoops, sorry you must enter an integer greater than zero.\n"
end
