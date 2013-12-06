require 'spec_helper'

describe Worker do 

  let(:lorem) {LoremIpsumWordSource.new(File.dirname(__FILE__) + '/../examples/lorem_ipsum.txt')} 
  
  context "when no block code set" do 
    let(:worker) {Worker.new(lorem, 'test')} 
  
    it "should initialize properly" do 
      worker.words.should eq ['test']
      worker.instance_variable_get(:@block). should be_nil
      lorem.instance_variable_get(:@observer_peers).keys.first.should eq worker
    end
  
    it "should run method when update called with registred word" do 
      expect {worker.update('test')}.to raise_error "implement in subclass"
    end
  end
  
   context "when block code is set" do 
    let(:worker) {Worker.new(lorem, 'test') {raise "block code"}} 
  
    it "should initialize properly" do 
      worker.words.should eq ['test']
      worker.instance_variable_get(:@block). should be_a Proc
      lorem.instance_variable_get(:@observer_peers).keys.first.should eq worker
    end
  
    it "should run method when update called with registred word" do 
      expect {worker.update('test')}.to raise_error "block code"
    end
  end 
end

