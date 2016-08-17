require './known_board'

class HumanPlayer < KnownBoard
  def get_move
    STDIN.gets.split.map(&:to_i)
  end
end
