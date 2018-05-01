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
  def to_string(%{black: black, white: white}) do
    white_index = index(white)
    black_index = index(black)

    0..127
    |> Enum.reduce("", fn
      127, acc -> acc
      i, acc when rem(i + 1, 16) == 0 -> acc <> "\n"
      i, acc when rem(i, 2) == 1 -> acc <> " "
      ^black_index, acc -> acc <> "B"
      ^white_index, acc -> acc <> "W"
      _i, acc -> acc <> "_"
    end)
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%{black: {row, _}, white: {row, _}}), do: true
  def can_attack?(%{black: {_, col}, white: {_, col}}), do: true

  for n <- 1..7 do
    def can_attack?(%{black: {b_row, b_col}, white: {w_row, w_col}})
        when (w_col == b_col + unquote(n) and w_row == b_row + unquote(n)) or
               (b_col == w_col + unquote(n) and b_row == w_row + unquote(n)) or
               (b_col == w_col - unquote(n) and b_row == w_row + unquote(n)) or
               (b_col == w_col + unquote(n) and b_row == w_row - unquote(n)),
        do: true
  end

  def can_attack?(_queens), do: false

  defp index({row, column}), do: row * 16 + column * 2
end
