module GameLogic
    def compare(code, guess)
        indexes = []
        code.enum_for(:each_char).each_with_index { |c, i| indexes << i if c == guess }
        updateCode(indexes, guess)
    end

    def checkRemaining(hiddenCode)
        if (hiddenCode.include?('_'))
            playerGuess()
        else
            puts "Congratulation! You found the secret word!".blue
            File.delete("./saved_games/saved_game_#{@input}.yaml") if File.exist?("./saved_games/saved_game_#{@input}.yaml")
            continuePlaying()
        end
    end

    def checkGuess(guess)
        if (guess == 'save')
            puts "Game saved!".yellow
            save() 
        end
        load() if (guess == 'load')
        if (guess == 'exit')
            puts "Thanks for playing!"
            exit
        end
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

    def checkFolder()
        folder = Dir.glob("saved_games/*")
        if (folder.length == 0)
            puts "There is no saved game."
            continuePlaying()
        else
            puts ""
            puts "Saved games: "
            folder.each_with_index{|name, index| puts "#{index + 1}. #{name.split("/")[1]}"}
            puts ""
        end
        folder.length
    end

    def displayInitialCode()
        puts @hiddenCode.blue + " " + @guessed.join(" ")
        playerGuess()
    end

    def displayTurnPrompt()
        <<~HEREDOC
        
        Guess a character.
        You can also type 'save' or 'exit' to leave the game.
        You have #{@lives} lives left.

        HEREDOC
    end
end