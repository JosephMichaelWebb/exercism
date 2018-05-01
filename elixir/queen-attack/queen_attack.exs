defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct black: nil, white: nil

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  @spec new({integer, integer}, {integer, integer}) :: Queens.t()

  def new(queen, queen), do: raise(ArgumentError)

  def new(white \\ {0, 3}, black \\ {7, 3}) do
    %Queens{white: white, black: black}
  end

  @doc """
  Gives a string reprentation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    {row, column} = queens.white
    white_index = row * 16 + column * 2
    {row, column} = queens.black
    black_index = row * 16 + column * 2

    to_string(white_index, black_index, "", 0)
  end

  def to_string(_white_index, _black_index, acc, 127) do
    acc
  end

  def to_string(white_index, black_index, acc, index)
      when rem(index + 1, 16) == 0 do
    to_string(white_index, black_index, acc <> "\n", index + 1)
  end

  def to_string(white_index, black_index, acc, index)
      when rem(index, 2) == 1 do
    to_string(white_index, black_index, acc <> " ", index + 1)
  end

  def to_string(white_index, black_index, acc, black_index) do
    to_string(white_index, black_index, acc <> "B", black_index + 1)
  end

  def to_string(white_index, black_index, acc, white_index) do
    to_string(white_index, black_index, acc <> "W", white_index + 1)
  end

  def to_string(white_index, black_index, acc, index) do
    to_string(white_index, black_index, acc <> "_", index + 1)
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%{black: {row, _}, white: {row, _}}) do
    true
  end

  def can_attack?(%{black: {_, col}, white: {_, col}}) do
    true
  end

  for n <- 1..7 do
    def can_attack?(%{black: {b_row, b_col}, white: {w_row, w_col}})
        when w_col == b_col + unquote(n) and w_row == b_row + unquote(n) do
      true
    end

    def can_attack?(%{black: {b_row, b_col}, white: {w_row, w_col}})
        when b_col == w_col + unquote(n) and b_row == w_row + unquote(n) do
      true
    end

    def can_attack?(%{black: {b_row, b_col}, white: {w_row, w_col}})
        when b_col == w_col - unquote(n) and b_row == w_row + unquote(n) do
      true
    end

    def can_attack?(%{black: {b_row, b_col}, white: {w_row, w_col}})
        when b_col == w_col + unquote(n) and b_row == w_row - unquote(n) do
      true
    end
  end

  def can_attack?(_queens), do: false
end
