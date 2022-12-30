module SaveLoad
    def save()
        folder = Dir.glob("saved_games/*")
        File.open("./saved_games/saved_game_#{folder.length + 1}.yaml", 'w'){|file| file.puts(YAML::dump(self))} if (@oldGameState == 0)
        File.open("./saved_games/saved_game_#{@input}.yaml", 'w'){|file| file.puts(YAML::dump(self))} if (@oldGameState == 1)
        exit
    end
    
    def load()
        folderLength = checkFolder()
        print "Select a game: "
        @input = gets.chomp.to_i
        puts ""
        until (@input.between?(1, folderLength))
            puts "File doesn't exist".yellow
            print "Select a game: "
            @input = gets.chomp.to_i
        end
        oldGame = Psych.unsafe_load(File.read("./saved_games/saved_game_#{@input}.yaml"))
        oldGame.oldGameState = 1
        oldGame.input = @input
        oldGame.displayInitialCode()
    end
end