defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """
  @skips ["What", "is", " ", "by", "?"]
  @ops %{"plus" => &+/2, "minus" => &-/2, "multiplied" => &*/2, "divided" => &div/2}
  @spec answer(String.t()) :: integer
  def answer(string, acc \\ [])
  def answer("", [result]), do: result
  def answer(string, [arg2, op, arg1]), do: answer(string, [op.(arg1, arg2)])
  for skip <- @skips, do: def(answer(unquote(skip) <> rest, acc), do: answer(rest, acc))

  for op <- Map.keys(@ops),
      do: def(answer(unquote(op) <> rest, acc), do: answer(rest, [unquote(@ops[op]) | acc]))

  def answer(string, acc) do
    {arg, rest} = parse_integer(string)
    answer(rest, [arg | acc])
  end

  defp parse_integer(string), do: with(:error <- Integer.parse(string), do: raise(ArgumentError))
end
