defmodule Wordy2 do
  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t()) :: integer
  def answer(question) do
    question
    |> trim()
    |> String.split(" ")
    |> Enum.map(&Parser.parse/1)
    |> calculate()
  end

  defp calculate([n1, operator, n2]) do
    apply(Kernel, operator, [n1, n2])
  end

  defp calculate([n1, operator, n2 | rest]) do
    calculated = apply(Kernel, operator, [n1, n2])
    calculate([calculated] ++ rest)
  end

  defp trim(question) do
    question
    |> String.trim_leading("What is ")
    |> String.trim_trailing("?")
    |> String.replace("by ", "")
  end
end

defmodule Parser do
  def parse("plus"), do: :+
  def parse("minus"), do: :-
  def parse("multiplied"), do: :*
  def parse("divided"), do: :div

  def parse(operand) do
    case Integer.parse(operand) do
      {integer, ""} -> integer
      _ -> raise ArgumentError
    end
  end
end
