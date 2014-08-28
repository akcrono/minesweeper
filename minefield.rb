require 'pry'

class Minefield
  attr_reader :row_count, :column_count

  def initialize(row_count, column_count, mine_count)
    @column_count = column_count
    @row_count = row_count
    @field = []
    @mine_count = mine_count
    @uncleared_count = column_count * row_count
    @row_count.times do |i|
      @field[i] = []
    end
    populate_minefield
  end

  def populate_minefield
    mines = @mine_count
    while mines > 0
      srand
      rand_row = rand(@row_count)
      rand_col = rand(@column_count)
      if @field[rand_row][rand_col] != 'mine'
        @field[rand_row][rand_col] = 'mine'
        mines -= 1
      end
    end
  end


  # Return true if the cell been uncovered, false otherwise.
  def cell_cleared?(row, col)
    if @field[row][col] == nil
      return false
    elsif @field[row][col] == 'mine'
      return false
    end
    true
  end

  # Uncover the given cell. If there are no adjacent mines to this cell
  # it should also clear any adjacent cells as well. This is the action
  # when the player clicks on the cell.
  def clear(row, col)
    # puts "currently checking #{row}, #{col}"
    if contains_mine?(row, col)
      @field[row][col] = 'boom'
    elsif !cell_cleared?(row, col)
      @field[row][col] = adjacent_mines(row, col)
      if @field[row][col] == 0
        if row > 0
          if col > 0
            clear(row - 1, col - 1)
          end
          clear(row - 1, col)
          if col < @column_count - 1
            clear(row - 1, col + 1)
          end
        end
        if col > 0
          clear(row, col - 1)
        end
        if col < @column_count - 1
          clear(row, col + 1)
        end
        if row < @row_count - 1
          if col > 0
            clear(row + 1, col - 1)
          end
          clear(row + 1, col)
          if col < @column_count - 1
            clear(row + 1, col + 1)
          end
        end
      end
      @uncleared_count -= 1
    end
  end

  # Check if any cells have been uncovered that also contained a mine. This is
  # the condition used to see if the player has lost the game.
  def any_mines_detonated?
    @field.each do |row|
      row.each do |col|
        if col == 'boom'
          return true
        end
      end
    end
    false
  end

  # Check if all cells that don't have mines have been uncovered. This is the
  # condition used to see if the player has won the game.
  def all_cells_cleared?
    if @mine_count == @uncleared_count
      return true
    end
    false
  end

  # Returns the number of mines that are surrounding this cell (maximum of 8).
  def adjacent_mines(row, col)
    total = 0
    if row > 0
      if col > 0
        total += 1 if contains_mine?(row - 1, col - 1)
      end
      total += 1 if contains_mine?(row - 1, col)
      if col < @column_count - 1
        total += 1 if contains_mine?(row - 1, col + 1)
      end
    end
    if col > 0
      total += 1 if contains_mine?(row, col - 1)
    end
    total += 1 if contains_mine?(row, col)
    if col < @column_count - 1
      total += 1 if contains_mine?(row, col + 1)
    end
    if row < @row_count - 1
      if col > 0
        total += 1 if contains_mine?(row + 1, col - 1)
      end
      total += 1 if contains_mine?(row + 1, col)
      if col < @column_count - 1
        total += 1 if contains_mine?(row + 1, col + 1)
      end
    end
    total
  end

  # Returns true if the given cell contains a mine, false otherwise.
  def contains_mine?(row, col)
    if @field[row][col] == 'mine'
      return true
    end
    false
  end
end
