require 'spec_helper'

describe LoremIpsumWordSource do 
  let(:lorem) {LoremIpsumWordSource.new(File.dirname(__FILE__) + '/../examples/lorem_ipsum.txt')} 

  it "should initialize properly" do 
    lorem.instance_variable_get(:@source_read).should be_a CommaFileSource
  end
  
  it "should read next word" do 
    lorem.next_word.should eq 'lorem'
    lorem.next_word.should eq 'ipsum'    
    lorem.next_word.should eq 'dolor'    
  end
  
  it "should present top sorted words" do 
    3.times {lorem.next_word}
    lorem.top_3_words.should eq ["lorem", "ipsum", 'dolor']
    lorem.top_5_words.should eq ["lorem", "ipsum", "dolor", nil, nil]    
  end  
  
  it "should read all the words" do 
    lorem.run
    lorem.count.should eq 4946
  end
end

describe TwitterWordSource do 
  let(:twitter) {TwitterWordSource.new('#google', File.dirname(__FILE__) + '/../examples/twitter.yml')}

  it "should initialize properly" do 
    twitter.instance_variable_get(:@source_read).should be_a TwitterSource
  end
  
end
