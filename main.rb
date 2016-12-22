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


# It's ugly and it only sort of works barely and I could spend more time on it but I wouldn't be confident
# in this work.
# standards_used = []
# quiz_array = questions_for_quiz.times.map.with_index(rand(0...questions_matrix.length)) do |strand_index|
#   strand = questions_matrix[strand_index.remainder questions_matrix.length]
#   standards_group = strand - standards_used
#   standard = standards_group.sample
#   standards_used << standard
#   question_id = standard.sample[:question_id]
#   binding.pry
#   question_id
# end
# puts quiz_array.join ', '


# NOTE / SUMMARY:
# The primary problem with all these solutions looping through the strands
# with conditions or not is that the standards end up being unequal because of randomness
# or we end up with the wrong output which forces us to keep the state
# of the strands / standards that have already been used during the generation process...


# Goes through each strand regardless of questions_for_quiz...
  # quiz_array = questions_matrix.flat_map do |strand|
  #   number_of_standards = strand.length
  #   if number_of_standards >= number_of_questions_needed_from_each_strand
  #     strand.flat_map(&:sample.(number_of_questions_needed_from_each_strand))
  #   end
  #   # binding.pry
  #   # # = number_of_questions_needed_from_each_strand / strand.length
  #   # number_of_questions_needed_from_each_strand.times.map do |i|
  #   #   strand[i.remainder number_of_standards]
  #   # end
  # end.map(&:[].(:question_id)) # return list of question_id's

# if questions_for_quiz.remainder number_of_strands == 0
#   number_of_flat_maps_to_perform = questions_for_quiz / number_of_strands
#   quiz_array = questions_matrix.cycle(number_of_flat_maps_to_perform) do |strand|
#     number_of_standards = strand.length
#     if number_of_standards >= number_of_questions_needed_from_each_strand
#       strand.flat_map(&:sample.(number_of_questions_needed_from_each_strand))
#     end
#   end.map(&:[].(:question_id))
#   puts quiz_array.join ', '
#   exit
# end

# quiz_array = questions_matrix.flat_map do |strand|
#   number_of_standards = strand.length
#   if number_of_standards >= number_of_questions_needed_from_each_strand
#     strand.flat_map(&:sample.(number_of_questions_needed_from_each_strand))
#   end
#   # binding.pry
#   # # = number_of_questions_needed_from_each_strand / strand.length
#   # number_of_questions_needed_from_each_strand.times.map do |i|
#   #   strand[i.remainder number_of_standards]
#   # end
# end.map(&:[].(:question_id)) # return list of question_id's




# first_strand_index = rand(0...questions_matrix.length)
# first_strand = questions_matrix[first_strand_index]

# first_standard_index = rand(0...first_strand.length)
# first_standard = first_strand[first_standard_index]

# first_question_index = rand(0...first_standard.length)
# first_question = first_standard[first_question_index]


#
# first_strand_index =


# Mimic CSV.table defaults
# options = {
#   headers: true,
#   converters: :numeric,
#   header_converters: :symbol
# }
# CSV.open 'data/questions.csv', options do |questions_table|
#   questions1 = questions_table.each
#   # Use each strand as close as possible to an equal number of times. (e.g. There are two strands, so if the user asks for a 3 question quiz, it's okay to choose one strand twice and the other once.)
#   strands = questions.map(&:[].(:strand_id))
#   puts strands
#   # Use each standard as close as possible to an equal number of times.
#   standards = questions.map(&:[].(:standard_id))
#   puts standards

#   # The expected output is to display a list of question_ids
#   # Duplicating questions in the quiz is OKAY!
# end

# questions_for_quiz.times.map do #=> returns an array of results.
#   rand(1..questions_table.)
# end

# questions_matrix = CSV.table(file_path).to_a

# puts questions_matrix.to_s
# puts questions_for_quiz

# Psuedo Code
# strand_ids : List Int
# strand_ids = [1...2]

# standard_ids : List Int
# standard_ids = [1...6]

# question_ids : List (Int, Difficulty)
# question_ids =
#   [ (1, 0.7)
#   , (2, 0.6)
#     ...
#   ]
