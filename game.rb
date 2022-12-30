require_relative 'game_logic.rb'
require_relative 'save_load.rb'

class Game
    include GameLogic
    include SaveLoad
    
    attr_accessor :code, :hiddenCode, :oldGameState, :input
    @@wordList = File.open('sample.txt', 'r')
    @@wordList = @@wordList.to_a.map{|word| word = word.chomp}

    def play()
        @oldGameState = 0
        mode = modeSelection()
        setCode(@@wordList) if mode == '1'
        load() if mode == '2'
    end
    
    def modeSelection()
        puts "Enter 1 to play new game."
        puts "Enter 2 to load a game."
        return input = gets.chomp
    end

    def setCode(wordList)
        @code = wordList.sample
        puts "Your random word has been choosen. It has #{@code.length} characters.".blue
        @hiddenCode = Array.new(@code.length, '_').join("")
        @lives = 8
        @guessed = []
        displayInitialCode()
    end

    def playerGuess()
        puts displayTurnPrompt()
        print "Enter your choice: "
        puts ""
        guess = gets.chomp.downcase
        checkGuess(guess)
    end

    def updateCode(indexes, guess)
        @guessed << guess
        if (indexes.length > 0)
            indexes.each do |i|
                @hiddenCode[i] = guess
            end
            puts @hiddenCode.blue + " " + @guessed.join(" ")
            puts ""
            checkRemaining(@hiddenCode)
        else
            puts "Sorry, #{guess} is not in the secret word."
            puts ""
            puts @hiddenCode.blue + " " + @guessed.join(" ")
            puts ""
            @lives = updateLives(@lives)
            playerGuess() if (@lives > 0)
        end
    end

    def updateLives(lives)
        lives -= 1
        if (lives == 0)
            puts "You were beaten. The secret code is #{@code}".red
            File.delete("./saved_games/saved_game_#{@input}.yaml") if File.exist?("./saved_games/saved_game_#{@input}.yaml")
        end
        lives
    end

    def continuePlaying()
        loop do
            print "Would you like to continue playing [y/n]: "
            input = gets.chomp.downcase
            if (input.match(/[yn]/) && input.length == 1)
                Game.new.play if input == 'y'
                if (input == 'n')
                    puts "Thanks for playing!"
                    exit
                end
            else
                puts "Invalid input! Please enter [y/n]: ".yellow
                continuePlaying()
            end
        end
    end
end
