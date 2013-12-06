$:.push File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'wsource'

#Testing file read and 3 types of callbacks
src = LoremIpsumWordSource.new

first_callback = MakeWarning.new src
first_callback << 'ipsum' << 'dolor'

second_callback = MakeWarning.new src, 'dolor', ' > Hello! - '
third_callback = CodeWorker.new(src, 'amet') {|w| puts '  > different way: ' + w}

5.times {src.next_word}
puts src.top_8_words.inspect
puts src.top_10_consonants.inspect
puts 'number of words: ' + src.count.to_s
puts

#unregister 2 observers
first_callback.stop_observing
third_callback.stop_observing

#reading all the file
puts src.run
puts src.top_5_words.inspect
puts src.top_5_consonants.inspect
puts 'number of words: ' + src.count.to_s
puts


#testing tweeter stream access
tweet = TwitterWordSource.new
tweet_callback = MakeWarning.new tweet, 'arsenal', ' > THIS IS ABOUT Arsenal - '

puts "Words from twitter"
5.times {puts tweet.next_word}
puts tweet.top_8_words.inspect
puts tweet.top_10_consonants.inspect
puts
puts 'number of words: ' + tweet.count.to_s

puts
puts 'Reading all stream by "run". For demonstration, "all twitter stream" means 10 tweets'
puts tweet.run
puts tweet.top_8_words.inspect
puts tweet.top_10_consonants.inspect
puts
puts 'number of words: ' + tweet.count.to_s

#change sorce of words to file
puts
puts '------------------------'
puts 'DYNAMIC change of source:'
puts
tweet.source_read = CommaFileSource.new('lorem_ipsum.txt')
5.times {tweet.next_word}
puts tweet.top_8_words.inspect
puts tweet.top_10_consonants.inspect
puts 'number of words: ' + tweet.count.to_s
puts
