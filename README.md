# hangman_RUBY
command line hangman game

check it out on repl.it  [https://repl.it/@SaltheSadmanSha/hangmanRUBY]

*rules*:
you have 6 tries to guess a secret word.
every wrong guess removes a try , you lose when you have 0 tries left.
if you guess the word before losing all the tries , you win.
visit [https://en.wikipedia.org/wiki/Hangman_(game)] for more.

you can -
 write 'save' to save your game at any turn
 write 'quit' to exit the game
 write 'pause' to save and exit

open the assosiated 'word_list.txt' file to see all the words used in the game.
only words between 5 and 12 letters are used . words are chosen randomly.


*Code description* :

 hangman.rb
  - conatains the base game class
  - keeps track of the rounds words and player inputs
  - uses json for serialization
  - saves the class in the designated file
  - all the outputs are text based 
  - can be used alone
  
 main.rb  
  - uses loops to make the game continuous
  - verifies player input and manages the save/load function
  - creates the base game object
  - stores save files to 'saves.json'
  - picks random words from 'word_list.txt' 
  - needs the other files to function properly  
