require 'colorize'

class Game
    attr_accessor :code, :hiddenCode
    def play()
        wordList = File.open('sample.txt', 'r')
        wordList = wordList.to_a.map{|word| word = word.chomp}
        setCode(wordList)
    end
    
    def setCode(wordList)
        @code = wordList.sample
        puts "Your random word has been choosen. It has #{@code.length} characters.".blue
        @hiddenCode = Array.new(@code.length, '_').join("")
        puts @hiddenCode.blue
        @lives = 8
        @guessed = []
        playerGuess()
    end

    def displayTurnPrompt()
        <<~HEREDOC
        
        Your turn to guess one letter in the secret word.
        You can also type 'save' or 'exit' to leave the game.
        You have #{@lives} lives left.

        HEREDOC
    end

    def playerGuess()
        puts displayTurnPrompt()
        print "Your guess: "
        guess = gets.chomp.downcase
        if (guess.match(/^[a-zA-Z]/))
            if (guess.length != 1)
                guess = checkLength(guess)
            end
            if (@guessed.include?(guess))
                guess = checkRepeated(guess)
            end
            compare(code, guess)
        else
            playerGuess()
        end
    end

    def compare(code, guess)
        indexes = []
        code.enum_for(:each_char).each_with_index { |c, i| indexes << i if c == guess }
        updateCode(indexes, guess)
    end

    def updateCode(indexes, guess)
        @guessed << guess
        if (indexes.length > 0)
            indexes.each do |i|
                @hiddenCode[i] = guess
            end
            puts @hiddenCode.blue + " " + @guessed.join(" ")
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

    def checkRemaining(hiddenCode)
        if (hiddenCode.include?('_'))
            playerGuess()
        else
            puts "Congratulation! You found the secret word!".blue
        end
    end

    def checkRepeated(guess)
        loop do
            print "You have guessed #{guess}. Please enter another character: ".yellow
            input = gets.chomp
            if (!@guessed.include?(input))
                return input.downcase
            end
        end
    end

    def checkLength(guess)
        loop do
            print "Please enter one character [a-z]: ".yellow
            input = gets.chomp
            if (input.length == 1 && input.match(/^[a-zA-Z]/))
                return input.downcase
            end
        end
    end

    def updateLives(lives)
        lives -= 1
        if (lives == 0)
            puts "You were beaten".red
        end
        lives
    end
end

Game.new.play