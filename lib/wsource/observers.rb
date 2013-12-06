
class Worker
extend Forwardable

  attr_accessor :words
  def_delegators :@words, :<<, :clear, :[]

  def initialize word_source, word=nil
    @words = []
    @words << word if word
    @block = Proc.new if block_given? 
    @word_source = word_source
    @word_source.add_observer(self)
  end
  
  def update word
    if @words.include? word
      @block ? @block.call(word) : make_job(word)
    end
  end  
  
  def stop_observing
    @word_source.delete_observer(self)
  end
  
  private
  def make_job word
    raise 'implement in subclass'
  end
end


#classes implementing Worker interface
#for demonstration purposes - parametrized method or block is used as callback action

class MakeWarning < Worker

  def initialize word_source, word=nil, message=nil
    @message = message || 'Standard warning: '
    super(word_source, word)
  end
  
  private
  def make_job word
    puts @message + word
  end
end

class CodeWorker  < Worker
  def initialize word_source, word=nil
    if block_given?
      super(word_source, word, &Proc.new)
    else
      raise "No block code"
    end  
  end
end

