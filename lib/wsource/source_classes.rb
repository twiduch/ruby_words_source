
class Source
  
  attr_reader :count
  
  def initialize
    @words = {}
    @consonants ={}
    @count = 0
  end

  def next_word
    raise "implement in subclass"
  end
  
  def top_words number
    top_hash(@words, number.to_i)
  end
  
  def top_consonants number
    top_hash @consonants, number.to_i
  end  
  
  private
  def add_word word 
    return unless word
    @count += 1
    word = clean_word(word.downcase)
    add_to_counted_hash @words, word.to_sym
    make_consonants word
    word
  end
    
  def add_to_counted_hash hash, symbol
    if hash[symbol]
      hash[symbol] += 1
    else
      hash[symbol] = 1
    end
  end
  
  def make_consonants word
    word = word.gsub(/[^a-z]/, '').gsub(/[aeiouy]/,'')
    word.chars.each {|c| add_to_counted_hash(@consonants, c.to_sym) }
  end
  
  def top_hash hash, number
    sorted = hash.sort_by { |elem, occur| -occur}.take(number).map {|e| e[0].to_s}
    (0..number-1).map {|i| sorted[i]}
  end
  
  def clean_word(word)
    word.sub(/^[\W]+/,'').reverse.sub(/^[\W]+/,'').reverse
  end

  class NoFileError < RuntimeError; end
  class EndOfFileError < IOError; end
  class NoClientError < RuntimeError; end 
    
end


#classes implementing Source interface

class CommaFileSource < Source
  attr_accessor :file
  def initialize(file = nil)
    raise NoFileError unless file && File.exist?(file)
    @file = File.new(file, "r")
    super()
  end
  
  def next_word
    word = @file.gets(',') 
    io_error unless word
    add_word(word)
  end
 
  private 
  def io_error
    @file.close 
    raise EndOfFileError
  end
end


class TwitterSource < Source
  attr_accessor :search_term
 
  def initialize(file=nil, term='#arsenal')
    raise NoFileError unless file && File.exist?(file)
    @search_term = term
    set_config file
    set_REST_client
    super()
  end
  
  def next_word
    raise NoClientError unless @client
    word = get_word_from_tweet(get_tweet_from_search)
    io_error if @count >= 10 #to be discussed (removed/changed) - for tests purposes
    add_word(word)
  end
  
  private
  def get_tweet_from_search
    @client.search(@search_term, count: 6, lang: 'en', result_type: "recent").to_a.sample
  end
  
  def get_word_from_tweet tweet
    tweet.text.split.sample if tweet
  end
  
  def set_config file
    @config ||= OpenStruct.new(YAML.load_file(file))
  end
  
  def set_REST_client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = @config.twitter['consumer_key']
      config.consumer_secret     = @config.twitter['consumer_secret']
    end
  end
  
  def io_error 
    raise EndOfFileError
  end
end
