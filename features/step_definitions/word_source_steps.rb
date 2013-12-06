Given(/^a file with comma delimited words '([\w\.]+)'$/) do |file|
  @source = LoremIpsumWordSource.new(File.dirname(__FILE__) + '/' + file) 
end

When(/^I read '(\d+)' consecuitive words$/) do |number|
  number.to_i.times {@source.next_word}
end

Then(/^I should receive list of '(\d+)' most frequent words$/) do |number, table|
  @word_table = table.raw.flatten
  @res_table = @source.send("top_#{number}_words".to_sym)
  @res_table.should eq @word_table
end

Then(/^list of '(\d+)' most frequent consonants$/) do |number, table|
  @cons_table = table.raw.flatten
  @res_table = @source.send("top_#{number}_consonants".to_sym)
  @res_table.should eq @cons_table  
end

