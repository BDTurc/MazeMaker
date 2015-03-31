#This is the main class for the mazes program.  It requires  maze loader class to convert the maze created by the mazemaker class from a string of binary numbers to a maze.  
require 'set'
require_relative 'mazemaker.rb'
require_relative 'mazeloader.rb'

class MazeSolver
  
  #The rows and columns actually refer to how many cells a maze can have, and not its actual size.  Hence a 4x4 maze has 4 cells in each dimension at max.  
  def initialize(x, y) 
    @dimensionx = x
    @dimensiony = y
    if @dimensionx <= 1 || @dimensiony <=1; print "dimensions must be greater than 2\n"; exit(1) end #if our dimensions are too small, exit. 
    @string_count = (y * 2) + 1 #actual number of rows
    @string_length = (x * 2) + 1 #actual number of columns
    @solution_queue = Set.new #needed to determine where to move
    @solution_traveled = Set.new #needed to determine where we moved
    @shortest_path = Hash.new #holds the coordinates of visited points to print the shortest path. 
    @maze = Array.new #our maze
  end
  
  #Main method, if no string is given, it will call the maze_load fumethod of the MazeLoader class and tell it to generate a maze at random.  Else, it loads the string given, displays it, picks a random start and end point to solve for, and solves.   
  def complete_maze(string = nil)
    our_maze = MazeLoader.new(@dimensionx, @dimensiony) #maze loader object
    @maze = our_maze.maze_load(string) #calls load maze from MazeLoader.
    our_maze.maze_display 
    beg_end = our_maze.start_end #picks random start / end points
    begx = beg_end[0]; begy = beg_end[1] 
    endx = beg_end[2]; endy = beg_end[3]
    maze_solve(begx, begy, endx, endy) #solves for the start/end
    maze_trace(begx, begy, endx, endy) #makes a literal trace of the path in the maze.
    puts "\nSolution, o = start E = end, | = path:\n\n"
    our_maze.maze_display(@maze) #displays the path taken.
  end
  #Performs a breadth-first search of the maze.  Will generate the shortest path.  
  def maze_solve(begx, begy, endx, endy)
    if @maze[begy][begx] == "1" || @maze[endy][endx]== "1"; print "cannot solve, start or end is a wall-space\n"; exit(1) end 
    @solution_queue.add([begy, begx]) #add our start point to a circular queue (implemented using set).
    @shortest_path[[begy, begx]] = [0, 0] #shortest path will store where each point in the solution came from, since the beg came from no-where, we can set it to 0,0.  
    until @solution_queue.empty? 
      currentmove = @solution_queue.take(1) 
      @solution_queue.subtract(currentmove) 
      currentmove.flatten!
      if (currentmove[0] != endy || currentmove[1] != endx) 
        create_next(currentmove[0], currentmove[1]) 
        @solution_traveled.add([currentmove[0], currentmove[1]]) #add the coordinates of the current move to the list of places we have been.
      else
        break 
      end
    end
  end
  
  #control method for generating all possible moves
  def create_next(y, x)
    move_left(y,x); move_right(y,x); move_down(y,x); move_up(y,x)
  end
  
  #all "move_x" methods act similarly, they check if an adjacent spot is an open cell, and if it is, whether or not it has been traveled to yet.  If it is open and hasn't been traveled to, add it to the end of the queue as a spot to visit. 
  def move_left(y, x)
    position = @maze[y][x-1]
    if position == "0" && @solution_traveled.include?([y, x-1]) == false
      @solution_queue.add([y, x-1, [y, x]])
      @shortest_path[[y, x-1]] = [y, x] #this adds the new position to the shortest path hash as a key, with the current coordinates as its value (representing where the new move came from).  
    end
  end
  
  def move_right(y, x)
    position = @maze[y][x+1]
    if position == "0" && @solution_traveled.include?([y, x+1]) == false
      @solution_queue.add([y, x+1, [y, x]])
      @shortest_path[[y, x+1]] = [y, x]
    end
  end
  
  def move_up(y, x)
    position = @maze[y-1][x]
    if position == "0" && @solution_traveled.include?([y-1, x]) == false
      @solution_queue.add([y-1, x, [y, x]])
      @shortest_path[[y-1 , x]] = [y, x]
    end
  end

  def move_down(y, x)
    position = @maze[y+1][x]
    if position == "0" && @solution_traveled.include?([y+1, x]) == false
      @solution_queue.add([y+1, x, [y, x]])
      @shortest_path[[y+1 , x]] = [y, x]
    end
  end
  
  #Maze_trace works by taking the shortest path hash and feeding it the termination point in the maze and the origin point in the maze.  Until the current spot is equal to the origin, mark every "current spot" in the maze with a '3' (the start and end are marked with a '2').  This is used by the display_maze method to draw a line from start to end.  
  def maze_trace(begx, begy, endx, endy)
    @maze[endy][endx] = '4' #mark end point in maze
    current_move = @shortest_path[[endy, endx]]  
    start_move = @shortest_path[[begy, begx]]  
   while current_move != start_move
     @maze[current_move[0]][current_move[1]] = '3' #marks this current spot as a visited spot for display_maze.  
     current_move = @shortest_path[current_move] #our next current_move becomes the move that generated the current_move (remember, this hash maps each coordinate pair with its predecessor pair).
   end
    @maze[begy][begx] = '2' #mark start point in maze
  end    
end

ydimension, xdimension, string = ARGV 
my_maze = MazeSolver.new(xdimension.to_i, ydimension.to_i)
my_maze.complete_maze(string)

