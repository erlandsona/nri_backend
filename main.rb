require 'csv'
require 'facets'
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


# not the most memory efficient but CSV.open with a block and enumerable only lets you
# go through the file once. I still haven't found a solution where that would be feasable.
# So CSV table it is.
questions_table = CSV.table 'data/questions.csv'

# Assume data exists and is non-zero
if questions_table.length < 1 then abort "Please create data/questions.csv with at least one question entry" end

# If user only needs one question just randomly pick one.
if questions_for_quiz == 1
  puts questions_table[:question_id].sample
  exit
end



questions_matrix =
  questions_table
  .group_by(&:[].(:strand_id)).values # returns [[]] where each child is a :strand
  .map(                              # go through each child and group strands by :standard
    &:group_by.(&:[].(:standard_id))
  ).map(&:values)                    # => [[[]]]

number_of_strands = questions_table[:strand_id].uniq.length
number_of_standards = questions_table[:standard_id].uniq.length

number_of_questions_needed_from_each_strand = questions_for_quiz / number_of_strands


if questions_for_quiz < number_of_strands
  quiz_array = questions_for_quiz.times.map.with_index(rand(0...number_of_strands)) do |strand_index|
    questions_matrix[strand_index.remainder number_of_strands].sample.sample[:question_id]
  end
  puts quiz_array.join ', '
  exit
end

if questions_for_quiz == number_of_strands
  quiz_array =
    questions_table
    .group_by(&:[].(:strand_id)).values # returns [[]] where each child is a :strand
    .map(&:sample) # map over list of strands since that's how many questions we need and sample from the list of questions
    .map(&:[].(:question_id))
  puts quiz_array.join ', '
  exit
end


# what if we start with standards once we know questions_for_quiz is greater than strands?





# See commit history for ugliness.
