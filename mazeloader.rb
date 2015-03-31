#This class will take a string of '1's or '0's and turn them into a two dimensional array of '1's and '0's, capable of being used as a maze.  It will also display the maze, by replacing each '1' with an 'x', and when solved, will display the traveled path in the maze.  
class MazeLoader
  
  #As with the other classes, our dimensions refer to cell count, while the actual size of a maze is determined by the string_count and string_length.  
  def initialize(dimensionx, dimensiony)
    @dimensionx = dimensionx
    @dimensiony = dimensiony
    @string_count = (dimensiony * 2) + 1
    @string_length = (dimensionx * 2) + 1
    @maze = Array.new
  end
  
  #If we are not given a string value, set it to default of nil.  The method will then call the MazeMaker class to return a string of 1's and 0's for us to use.  If we are given a string, it checks if it is long enough to create a valid maze, given the dimensions specified by user.  
  def maze_load(string = nil)
    if string == nil
      our_maze = MazeMaker.new(@dimensionx, @dimensiony)
      string = our_maze.maze_generate #generates a binary string at random of dimensions specified.
    end
    if string.length != @string_count * @string_length; print "string not correct size  for given dimensions\n"; exit(1) end 
    strings = string.scan(/.{#{@string_length}}/) #creates an array of sub-strings, equal in length to the needed dimension
    strings.each do |row|
      ary = []
      row.each_char do |char| #take each character in the sub-string
        if char != '1' && char != '0' 
          puts "Illegal values in your string.  Must be '1' or '0'"; exit(1)
        end
        ary.push(char) #push into that row's array. 
      end
      @maze.push(ary) #push the array into the main array.  
    end
    return @maze 
  end
  
  #takes the now 2-d array based maze, and picks the coordinates (the index values of the maze, essentially) randomly until it finds a beginning which is a '0' and an end which is '0' (and which is not equal to the beginning spot).  
  def random_start_end
    start = -1
    finish = -1
    until start != -1 #until start is valid
      startx = rand(@string_length-3) + 1; starty = rand(@string_count-3) + 1 #pick random coordinates
      start = 1 if @maze[starty][startx] == '0' 
    end
    until finish != -1 #until end is found
      endx = rand(@string_length-3) + 1; endy = rand(@string_count-3) + 1 #pick random coordinates
      finish = 1 if @maze[endy][endx] == '0' && (endy != starty || endx != startx)
    end
    return ary = [startx, starty, endx, endy]
  end
  
  #allows the user to choose their own start and end points
  def choose_start_end
    puts "Note that the TOP LEFT CORNER WALL is index (0,0) and the BOTTOM RIGHT CORNER WALL of a 4x4 maze is (8,8)."
    puts "Please enter your start x coordinate:"
    startx = $stdin.gets.chomp.to_i.abs
    puts "Please enter your start y coordinate:"
    starty = $stdin.gets.chomp.to_i.abs
    puts "Please enter your end x coordinate:"
    endx = $stdin.gets.chomp.to_i.abs
    puts "Please enter your end y coordinate:"
    endy = $stdin.gets.chomp.to_i.abs
    if startx >= @string_length || endx >= @string_length || starty >= @string_count || endy >= @string_count
      puts "Your start/end positions fall outside of the maze"; exit(1) end
    return ary = [startx, starty, endx, endy]
  end

  def start_end
    puts "Would you like to choose your start and end points?  Type Y for yes, or type N to generate random start end points:"
    choice = $stdin.gets.chomp
    if choice == "Y" || choice == "y"
      return choose_start_end
    else
      return random_start_end
    end
  end

  #Prints out a visual representation of the maze.  
  def maze_display(maze = @maze)
    @maze.each do |rowval|
       rowval.each do |char|
        if char == '1'; print 'x' #if the spot is a wall, put an x
        elsif char == '2'; print 'o' 
        elsif char == '3'; print '|' 
        elsif char == '4'; print 'E'
        else print ' ' #if spot is an open cell, put a blank space. 
        end
      end
      print "\n"
    end
  end
end

