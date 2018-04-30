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
  @blank "_"
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    {row, column} = queens.white
    white_index = row * 8 + column
    {row, column} = queens.black
    black_index = row * 8 + column

    0..63
    |> Enum.map(fn
      ^white_index -> "W"
      ^black_index -> "B"
      _index -> "_"
    end)
    |> Enum.chunk_every(8)
    |> Enum.map(fn row -> Enum.join(row, " ") end)
    |> Enum.join("\n")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(queens) do
  end
end
