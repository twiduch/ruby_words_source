require 'spec_helper'

describe Source do 
  let(:src) {Source.new}
  before do 
    src.send :add_word, 'lorem'
    src.send :add_word, 'ipsum'
    src.send :add_word, 'ipsum'
  end
  
  it "should initialize properly" do 
    src.instance_variable_get(:@words).should be_a Hash
    src.instance_variable_get(:@consonants).should be_a Hash  
  end
  
  it "should show top words properly" do 
    src.top_words(5).should eq ["ipsum","lorem",nil, nil, nil]
  end
  
  it "should show top consonants properly" do 
    src.top_consonants(5).should eq ["m","p","s","r","l"]
  end  
  
  it "should return nil if there is no word" do 
    src.send(:add_word, nil).should be_nil
  end
  
  it "should return the number of words added" do 
    src.count.should eq 3
    expect {src.send(:add_word, 'lorem')}.to change {src.count}.by 1
  end
  
  it "should add consonants only" do 
    src.send(:make_consonants, '.....bbbb%%%%0000')
    src.instance_variable_get(:@consonants).keys.should include :b
    src.instance_variable_get(:@consonants).keys.should_not include '.'.to_sym   
    src.instance_variable_get(:@consonants).keys.should_not include '%'.to_sym    
    src.instance_variable_get(:@consonants).keys.should_not include '0'.to_sym             
  end
  
  it "should add clean words" do 
    src.send :add_word, '"Glory" -:'
    src.instance_variable_get(:@words).keys.should include :glory      
  end
end

describe CommaFileSource do 
  let(:fs) {CommaFileSource.new(File.dirname(__FILE__) + '/../examples/lorem_ipsum.txt')}
  
  it "should raise error if no file given" do 
    expect{CommaFileSource.new}.to raise_error Source::NoFileError
  end
  
  it "should raise error if non existing file" do 
    expect{CommaFileSource.new('no_file')}.to raise_error Source::NoFileError
  end
  
  it "should open file if file exists" do 
    fs.instance_variable_get(:@file).should be_a File
  end
  
  it "should read consecutive words" do 
   fs.next_word.should eq 'lorem'
   fs.next_word.should eq 'ipsum' 
   fs.next_word.should eq 'dolor'     
  end
  
  it "should present top density-sorted words" do 
    3.times {fs.next_word}
    fs.top_words(3).should eq ["lorem", "ipsum", "dolor"]
    fs.top_words(5).should eq ["lorem", "ipsum", "dolor", nil, nil]    
  end
  
  it "should present top density-sorted consonants" do 
    6.times {fs.next_word}
    fs.top_consonants(3).should eq %w(t m r)
    fs.top_consonants(5).should eq %w(t m r s l)    
  end
  
  it "should display number of words read" do 
    3.times {fs.next_word}
    fs.count.should eq 3  
  end
  
  it "should raise error if reading after EOF" do 
    expect {loop {fs.next_word}}.to raise_error Source::EndOfFileError
  end
end

describe TwitterSource do
  let(:ts) {TwitterSource.new(File.dirname(__FILE__) + '/../examples/twitter.yml')}
  let(:conf_key) {ts.instance_variable_get(:@config).twitter['consumer_key']}
  let(:conf_sec) {ts.instance_variable_get(:@config).twitter['consumer_secret']}
  let(:cl_key) {ts.instance_variable_get(:@client).consumer_key}
  let(:cl_sec) {ts.instance_variable_get(:@client).consumer_secret}
  
  before { ts.stub(:get_tweet_from_search) {double(text: 'hello')} }
    
  it "should raise error if no conf file given" do 
    expect{CommaFileSource.new}.to raise_error Source::NoFileError
  end
  
  it "should raise error if non existing conf file" do 
    expect{CommaFileSource.new('no_file')}.to raise_error Source::NoFileError
  end
  
  it "should initialize properly" do 
    ts.instance_variable_get(:@words).should be {}
    cl_key.should eq conf_key
    cl_sec.should eq conf_sec
  end
  
  it "should read words from twitter" do 
    ts.next_word.should eq 'hello'
  end
  
end
