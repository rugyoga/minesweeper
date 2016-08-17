require './known_board'

class ComputerPlayer < KnownBoard
  def initialize(dimension, mines)
    super(dimension, dimension)
    max            = dimension - 1
    @corners       = [[0, 0], [0, max], [max, 0], [max, max]].shuffle
    @mines         = mines
    @moves         = []
    @safes         = []
    @bombs         = []
  end

  def random_move
    until unknown?(x = rand(@width), y = rand(@height))
    end
    [x, y]
  end

  def add_bombs(bombs)
    bombs.each do |x, y|
      if unknown?(x, y)
        flag!(x, y)
        @bombs.push([x, y])
      end
    end
  end

  def add_safes(squares)
    @safes.concat(squares).uniq!
  end

  def all_unknowns_are_bombs(x, y)
    count = get(x, y)
    us = adjacent_match(x, y, UNKNOWN)
    bs = adjacent_match(x, y, FLAGGED)
    add_bombs(us) if !us.empty? && count == bs.length + us.length
  end

  def all_unknowns_are_safes(x, y)
    count = get(x, y)
    unknowns = adjacent_match(x, y, UNKNOWN)
    bombs = adjacent_match(x, y, FLAGGED)
    add_safes(unknowns) if !unknowns.empty? && count == bombs.length
  end

  def set(x, y, c)
    super(x, y, c)
    return if c == EXPLODED
    all_unknowns_are_bombs(x, y)
    all_unknowns_are_safes(x, y)
  end

  def check_all_counts
    each.select { |_, _, c| c >= 0 }.sort_by { |x, y, c| [c, x, y] }.each do |x, y, count|
      unknowns = adjacent_match(x, y, UNKNOWN)
      next if unknowns.empty?
      bombs = adjacent_match(x, y, FLAGGED)
      add_bombs(unknowns) if count == bombs.length + unknowns.length
      add_safes(unknowns) if count == bombs.length
    end
  end

  def get_move
    check_all_counts if @safes.empty?
    if @safes.empty?
      c = @corners.select { |x, y| unknown?(x, y) }
      if c.empty?
        random_move
      else
        c.pop
      end
    else
      @safes.pop
    end.tap do |m|
      @moves << m
    end
  end
end
