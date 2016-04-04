#!/usr/bin/env ruby
require './known_board'
require './mine_board'

class Minesweeper
  def initialize(dimension, mines, player)
    @dimension   = dimension
    @mines       = mines
    @player      = player
    @state       = :running
    @mine_board  = MineBoard.new(dimension, dimension, mines)
    @move_number = 1
  end

  def to_s(x, y)
    @state == :won && !@player.known?( x, y ) ? '*' : @player.to_s(x, y)
  end

  def display
    @dimension.times do |y|
      puts @dimension.times.map{ |x| to_s(x, y) }.join
    end
  end

  def play_move(xy)
    x, y = xy
    @move_number += 1
    @player.set(x, y, @mine_board.get(x, y))
    @mine_board.mine?(x, y)
  end

  def check_win
    @dimension * @dimension == @move_number - 1 + @mines
  end

  def run(show=true)
    while @state == :running
      display if show
      m = @player.get_move()
      puts "##{@move_number}: #{m[0]},#{m[1]}" if show
      if play_move(m)
        puts "Mine exploded!" if show
        @state = :lost
      elsif check_win
        puts "All mines found!" if show
        @state = :won
      end
    end
    display if show
    @state == :won
  end
end
