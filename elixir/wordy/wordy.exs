defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t()) :: integer
  def answer(question) do
    with {:ok, operation} <- Question.to_operation(question) do
      Operation.execute(operation)
    end
  end
end

defmodule Question do
  def to_operation(question) do
    question
    |> trim
    |> Operation.parse()
  end

  defp trim(question) do
    question
    |> String.trim_leading("What is ")
    |> String.trim_trailing("?")
  end
end

defmodule Operation do
  @fields ~w(operator operands)a
  @enforce_keys @fields
  defstruct(@fields)

  def parse(operation) do
    operation
    |> String.split()
    |> case do
      [operand_1, operator, operand_2] ->
        parse_single_binary_operation(operand_1, operator, operand_2)

      _ ->
        {:error, :failed_to_parse}
    end
  end

  def execute(%Operation{operator: :+} = operation) do
    apply(Kernel, :+, operation.operands)
  end

  defp parse_single_binary_operation(operand_1, operator, operand_2) do
    with {:ok, operand_1} <- Operand.parse(operand_1),
         {:ok, operator} <- Operator.parse(operator),
         {:ok, operand_2} <- Operand.parse(operand_2) do
      {:ok,
       %Operation{
         operator: operator,
         operands: [operand_1, operand_2]
       }}
    end
  end
end

defmodule Operand do
  def parse(operand) do
    case Integer.parse(operand) do
      {integer, ""} -> {:ok, integer}
      :error -> {:error, :failed_to_parse_operand, operand}
    end
  end
end

defmodule Operator do
  def parse("plus"), do: {:ok, :+}

  def parse(operator) do
    {:error, :failed_to_parse_operator, operator}
  end
end
