#!/usr/bin/env ruby

class Square
  attr_reader :x, :y
  attr_accessor :marker, :transparent

  def initialize(x, y, marker, transparent=false)
    @x, @y, @marker, @transparent = x, y, marker, transparent
  end

  def display(canvas)
    canvas[@x][@y] = @marker unless @transparent
  end
end

class Board
  attr_reader :height, :width
  attr_accessor :squares

  def initialize(width, height, defaultMarker)
    @width, @height = width, height
    @squares = Array.new(@width){ |x| Array.new(@height){ |y| Square.new( x, y, defaultMarker ) } }
  end

  def legal(x, y)
    0 <= x && x < @width && 0 <= y && y < @height
  end

  def adjacent(x, y)
    left,  right = x-1, x+1
    above, below = y-1, y+1
    [[left, above], [x, above], [right, above],
     [left, y],                 [right, y],
     [left, below], [x, below], [right, below]]
     .select{ |x,y| legal(x,y) }
  end

  def adjacent?(square, x, y)
    (square.x - x).abs < 2 and (square.y - y).abs < 2
  end

  def display(canvas)
    @squares.each{ |column| column.each{ |square| square.display(canvas) } }
  end

  def move(x,y)
  end
end

class MineBoard < Board
  MINE_MARKER = "*"
  EMPTY_MARKER = "."
  EXPLODED_MARKER = "X"

  def initialize(width, height, mines)
    super(width, height, EMPTY_MARKER)
    @mines = mines
    @mines.each do |x, y|
      @squares[x][y] = Square.new( x, y, MINE_MARKER )
    end

    @width.times do |x|
      @height.times do |y|
        square = @squares[x][y]
        unless square.marker == MINE_MARKER
          count = adjacent_mines_count(square)
          square.marker = String(count) if count > 0
        end
      end
    end
  end

  def adjacent_mines_count(square)
    adjacent(square.x, square.y).count{ |x, y| isMine(x, y) }
  end

  def move(x,y)
    @squares[x][y].marker = EXPLODED_MARKER if result = isMine(x,y)
    result
  end

  def isMine(x,y)
    @squares[x][y].marker == MINE_MARKER
  end
end

class KnownBoard < Board
  UNKNOWN_MARKER = "_"
  KNOWN_MARKER = "K"
  FLAG_MARKER = "F"

  def initialize(width, height)
    super(width, height, UNKNOWN_MARKER)
  end

  def move(x,y)
    square = @squares[x][y]
    if square.marker == UNKNOWN_MARKER
      square.marker = KNOWN_MARKER
      square.transparent = true
    end
  end

  def isUnknown(x,y)
    @squares[x][y].marker == UNKNOWN_MARKER
  end
end


class Minesweeper
  def initialize(width, height, numMines)
    @width      = width
    @height     = height
    @mines      = randMines(numMines)
    @running    = true
    @mineBoard  = MineBoard.new(@width, @height, @mines)
    @knownBoard = KnownBoard.new(@width, @height)
    @moveNumber = 0
  end

  def randMine(mines)
    mine = nil
    while mines[mine = [rand(@width), rand(@height)]] ; end
    mine
  end

  def randMines(numMines)
    mines = Hash.new(false)
    numMines.times { |i| mines[randMine(mines)] = true }
    mines.keys
  end

  def display()
    canvas = Array.new(@width){ |i| Array.new(@height) }
    @mineBoard.display(canvas)
    @knownBoard.display(canvas) if @running
    @height.times do |y|
      @width.times { |x| print canvas[x][y] }
      puts
    end
  end

  def move()
    @moveNumber += 1
    print "move ##{@moveNumber}: x y = "
    x, y = gets.split().map{ |s| Integer(s) }
    @knownBoard.move(x,y)
    @mineBoard.move(x,y)
  end

  def checkWin()
    @width * @height == @moveNumber + @mines.length
  end

  def run()
    while @running
      display()
      if move()
        puts "Mine exploded!"
        @running = false
      elsif checkWin()
        puts "All mines found!"
        @running = false
      end
    end
    display()
  end
end

print "Enter: width/height numberOfMines = "
width_height, mines = gets.split()
minesweeper = Minesweeper.new(Integer(width_height), Integer(width_height), Integer(mines))
minesweeper.run()
