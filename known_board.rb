require './board'

class KnownBoard < Board
  UNKNOWN  = -3
  FLAGGED  = -2
  EXPLODED = -1

  def initialize(width, height)
    super(width, height, UNKNOWN)
  end

  def known?(x,y)
    get(x, y) != UNKNOWN
  end

  def unknown?(x,y)
    get(x, y) == UNKNOWN
  end

  def flag!(x,y)
    set(x, y, FLAGGED)
  end

  def flagged?(x,y)
    get(x, y) == FLAGGED
  end

  def to_s(x, y)
    c = get(x, y)
    case c
    when UNKNOWN  then '_'
    when FLAGGED  then 'F'
    when EXPLODED then 'X'
    when 0        then '.'
    else c.to_s
    end
  end
end
