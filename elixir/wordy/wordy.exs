defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t()) :: integer
  def answer(question) do
    question
    |> String.trim_leading("What is ")
    |> String.trim_trailing("?")
    |> String.split()
    |> Enum.flat_map(&parse_token/1)
    |> solve()
  end

  defp parse_token("by"), do: []
  defp parse_token("plus"), do: [&Kernel.+/2]
  defp parse_token("minus"), do: [&Kernel.-/2]
  defp parse_token("multiplied"), do: [&Kernel.*/2]
  defp parse_token("divided"), do: [&Kernel.div/2]
  defp parse_token(token), do: [String.to_integer(token)]

  defp solve([result]), do: result
  defp solve([int_1, op, int_2 | tokens]), do: solve([op.(int_1, int_2) | tokens])
end
