Feature: Using comma delimited file as source of words
  In order to generate statistics
  I want to read the comma delimited file
  As a rusult I need a list of most frequent words
  And a list of most frequent consonants

  Scenario: Read 10 words from the file
    Given a file with comma delimited words 'test.txt'
    When I read '10' consecuitive words
    Then I should receive list of '3' most frequent words
      | loro | ipsum | rono |
    And list of '5' most frequent consonants
      | r | l | m | s | p |
