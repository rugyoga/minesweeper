require './board'
require 'test/unit'

class TestBoard < Test::Unit::TestCase
  def test_board
    board = Board.new(3, 3, false)
    board.set(0, 0, true)
    assert_true(board.get(0, 0))
  end

  def test_get
    board = Board.new(2, 2, -1)
    assert_equal(board.get(0, 0), -1)
    assert_equal(board.get(0, 1), -1)
    assert_equal(board.get(1, 0), -1)
    assert_equal(board.get(1, 1), -1)
    assert_equal(board.get(2, 0), -1)
    assert_equal(board.get(2, 1), -1)
  end

  def test_set
    board = Board.new(2, 2, -1)
    board.set(0, 0, 1)
    assert_equal(board.get(0, 0),  1)
    assert_equal(board.get(0, 1), -1)
    assert_equal(board.get(1, 0), -1)
    assert_equal(board.get(1, 1), -1)
    assert_equal(board.get(2, 0), -1)
    assert_equal(board.get(2, 1), -1)
  end

  def test_each
    board = Board.new(3, 3, false)
    board.set(0, 0, true)
    board.each do |x, y, s|
      assert_equal(x, 0)
      assert_equal(y, 0)
      assert_true(s)
    end
    assert_equal(board.each.count, 1)
  end

  def test_adjacent
    board = Board.new(3, 3, false)
    board.adjacencies(1, 1).each do |x, y|
      assert_true(board.adjacent?(1, 1, x, y))
    end
  end

  def test_legal
    board = Board.new(3, 3, false)
    board.adjacent(1, 1).each do |x, y|
      assert_true(board.legal?(x, y))
    end
    assert_false(board.legal?(-1, 1))
    assert_false(board.legal?(1, -1))
    assert_false(board.legal?(-1, -1))
  end
end
