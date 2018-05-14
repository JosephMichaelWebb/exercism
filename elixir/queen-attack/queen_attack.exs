defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct black: {7, 3}, white: {0, 3}

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  def new(), do: %Queens{}

  @spec new({integer, integer}, {integer, integer}) :: Queens.t()
  def new(queen, queen), do: raise(ArgumentError)
  def new(white, black), do: %Queens{white: white, black: black}

  defguard end_of_line(i) when rem(i + 1, 16) == 0
  defguard between_space(i) when rem(i, 2) == 1
  @last_index 127

  @doc """
  Gives a string reprentation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(%{black: black, white: white}) do
    white_index = index(white)
    black_index = index(black)

    Enum.reduce(0..@last_index, "", fn
      @last_index, acc -> acc
      i, acc when end_of_line(i) -> acc <> "\n"
      i, acc when between_space(i) -> acc <> " "
      ^black_index, acc -> acc <> "B"
      ^white_index, acc -> acc <> "W"
      _i, acc -> acc <> "_"
    end)
  end

  defguard is_diagonal(w_col, w_row, b_col, b_row) when abs(w_col - b_col) == abs(w_row - b_row)

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%{black: {b_row, b_col}, white: {w_row, w_col}})
      when b_row == w_row
      when b_col == w_col
      when is_diagonal(w_col, w_row, b_col, b_row) do
    true
  end

  def can_attack?(_queens) do
    false
  end

  defp index({row, column}), do: row * 16 + column * 2
end
