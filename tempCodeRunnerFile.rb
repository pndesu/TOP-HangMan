s = "a#asg#sdfg#d##"
p a = (0 ... s.length).find_all { |i| s[i,1] == '#' }