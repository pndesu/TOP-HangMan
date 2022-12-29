class Game
    attr_accessor :code, :hiddenCode
    def play()
        wordList = File.open('sample.txt', 'r')
        wordList = wordList.to_a.map{|word| word = word.chomp}
        setCode(wordList)
    end
    
    def setCode(wordList)
        @code = wordList.sample
        puts @hiddenCode = Array.new(@code.length, '_').join
        playerGuess()
    end

    def playerGuess()
        guess = gets.chomp
        if (guess.match(/^[a-zA-Z]/))
            compare(code, guess.downcase)
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
        if (indexes.length > 0)
            indexes.each do |i|
                @hiddenCode = @hiddenCode.split("")
                @hiddenCode[i] = guess
            end
            puts @hiddenCode = @hiddenCode.join("")
            checkRemaining(@hiddenCode)
        else
            puts "No character found!"
            playerGuess()
        end
    end

    def checkRemaining(hiddenCode)
        if (hiddenCode.include?('_'))
            playerGuess()
        else
            puts "Secret word found!"
        end
    end
end

Game.new.play




# p a = (0 ... s.length).find_all { |i| s[i,1] == '#' } 

