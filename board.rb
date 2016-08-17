class Board
  attr_reader :height, :width

  def initialize(width, height, default)
    @width = width
    @height = height
    @default = default
    @blank_column = Hash.new(@default)
    @board = {}
  end

  def set(x, y, c)
    (@board[x] ||= Hash.new(@default))[y] = c
  end

  def get(x, y)
    @board.fetch(x, @blank_column)[y]
  end

  def legal?(x, y)
    0 <= x && x < @width && 0 <= y && y < @height
  end

  def adjacencies(x, y)
    left = x - 1
    right = x + 1
    above = y - 1
    below = y + 1
    [[left, above], [x, above], [right, above],
     [left, y],                 [right, y],
     [left, below], [x, below], [right, below]]
      .select { |p, q| legal?(p, q) }
  end

  def adjacent_match(x, y, c)
    adjacencies(x, y).select { |p, q| get(p, q) == c }
  end

  def adjacent?(x1, y1, x2, y2)
    (x1 - x2).abs < 2 && (y1 - y2).abs < 2 && !(x1 == x2 && y1 == y2)
  end

  def each
    if block_given?
      @board.each do |x, column|
        column.each { |y, square| yield(x, y, square) }
      end
    else
      triples = []
      each { |x, y, s| triples << [x, y, s] }
      triples
    end
  end
end
