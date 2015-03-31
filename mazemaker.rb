#This is the class which generates a random maze for the maze solver class.  It takes the set of dimensions fed to maze solver, and uses them to generate a maze of that size.  Functions by using a modified version of Prim's algorithm.  
class MazeMaker
  def initialize(x, y)
    @row_count = y * 2 + 1
    @row_length = x* 2 + 1
  end
  
  #Main generation Method.  Maze is stored as an array of arrays, with each sub-array containing the contents of one "row" of the maze.  Initializes all spaces to be walls, except for the first spot at coordinate 1,1.  Algorithm creates the maze by adding each wall of the current cell to a list, picking one at random, and if the which is seperated by the wall from the current cell is also a wall, turns that into the current open cell, and repeats the process.  
  def maze_generate
    @list = Array.new #our wall list
    @new_maze = Array.new(@row_count) { Array.new(@row_length, '1') }
    @new_maze[1][1] = '0' #our beginning spot
    @list.push([1,2, :w]); @list.push([2,1, :s]) #pushes the surrounding walls.  
    until @list.empty? #while there are still walls to perform alogrithm on, continue.
      coordinates = @list.delete(@list.sample) #remove a random wall and check it.
      y = coordinates[0]; x = coordinates[1]; direc = coordinates[2] #pass wall's coordinates to wall_change
      wall_change(y, x, direc)
    end
    convert_maze_binary
  end

  #wall change takes the coordinates of the wall, and by using the N,S,E,W marker also passed to it, knows which direction the open cell it came from is (this lets it check the correct direction opposite of that open cell). Notice that the rowcount and rowlength variables are modified by "-2," this is to ensure that they do not interact with the outer maze wall which surrounds the actual maze.   
  def wall_change(y, x, direc)
    if direc == :n && ((y-1) >= 1 && x >= 1)#if origin cell is above wall
      if @new_maze[y-1][x] == '1' #if cell across from open cell is a wall
        @new_maze[y-1][x] = '0'; @new_maze[y][x] = '0'; list_add(y-1, x) #make it and wall a cell, add its walls to the list.
      end
    end
    if direc == :s && ((y+1) <= @row_count-2 && x >= 1)#if origin cell is below wall
      if @new_maze[y+1][x] == '1' 
        @new_maze[y+1][x] = '0'; @new_maze[y][x] = '0'; list_add(y+1, x) 
      end
    end
    if direc == :w && (y >= 1 && (x+1) <= @row_length-2)#if origin cell is left of wall
      if @new_maze[y][x+1] == '1' 
        @new_maze[y][x+1] = '0'; @new_maze[y][x] = '0'; list_add(y, x+1)
      end
    end
    if direc == :e && (y >= 1 && (x-1) >= 1)#if origin cell is right of wall
      if @new_maze[y][x-1] == '1'
        @new_maze[y][x-1] = '0'; @new_maze[y][x] = '0'; list_add(y, x-1)
      end
    end
  end

  #This method adds all of the walls around the cell opened up in the "wall_change" method. 
  def list_add(y, x)
    @list.push([y+1, x, :s])  if y!= @row_count-2 && @new_maze[y+1][x] == '1' 
    @list.push([y-1, x, :n])  if y!= 1 && @new_maze[y-1][x] == '1' 
    @list.push([y, x+1, :w])  if x!= @row_length-2 && @new_maze[y][x+1] == '1'
    @list.push([y, x-1, :e])  if x!= 1 && @new_maze[y][x-1] == '1' 
  end
  
  #Because the maze is stored as a 2-d array, and we need our program to be capable of just taking strings as input, this flattens the array into 1-d and converts the entire thing into a string.
  def convert_maze_binary
    @maze_string = '' #intialize our string
    @new_maze.flatten!
    @new_maze.each do |num|
      @maze_string = @maze_string + num #concatenate the current string with the new 1 or 0.
    end
    return @maze_string
  end
end 
  
