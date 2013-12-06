#strategy pattern for decoupling from word sources
#pub/sub pattern for callbacks


class WordSource
  include Observable
  attr_accessor :source_read
  
  def next_word
    word = @source_read.next_word
    changed
    notify_observers(word)
    word
  end
 
  def method_missing(m, *args)
    case m.to_s
      when /\Atop_(\d+)_words\Z/
        @source_read.top_words($1)
      when /\Atop_(\d+)_consonants\Z/
        @source_read.top_consonants($1)
      else
        super
    end
  end  
  
  def count
    @source_read.count
  end
  
  def run
    loop {next_word} rescue Source::EndOfFileError
    true
  end
end


#classes implementing WordSource interface
#source can be dynamically changed if needed during run-time

class LoremIpsumWordSource < WordSource
  def initialize file = 'lorem_ipsum.txt'
    @source_read = CommaFileSource.new(file)
  end
end

class TwitterWordSource < WordSource
  def initialize term = '#arsenal', file = 'twitter.yml'
    @source_read = TwitterSource.new(file, term)
  end
end
