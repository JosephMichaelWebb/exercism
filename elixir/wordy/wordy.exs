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
    |> String.replace("by ", "")
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

      [operand_1, operator_1, operand_2, operator_2, operand_3] ->
        parse_two_binary_operation(operand_1, operator_1, operand_2, operator_2, operand_3)

      _ ->
        {:error, :failed_to_parse}
    end
  end

  def execute(
        %Operation{
          operands: [%Operation{} = inner_operation, operand]
        } = outer_operation
      ) do
    execute(%{outer_operation | operands: [execute(inner_operation), operand]})
  end

  def execute(%Operation{operator: operator} = operation) do
    apply(Kernel, operator, operation.operands)
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

  defp parse_two_binary_operation(operand_1, operator_1, operand_2, operator_2, operand_3) do
    with {:ok, operand_1} <- Operand.parse(operand_1),
         {:ok, operator_1} <- Operator.parse(operator_1),
         {:ok, operand_2} <- Operand.parse(operand_2),
         {:ok, operator_2} <- Operator.parse(operator_2),
         {:ok, operand_3} <- Operand.parse(operand_3) do
      {:ok,
       %Operation{
         operator: operator_2,
         operands: [
           %Operation{
             operator: operator_1,
             operands: [operand_1, operand_2]
           },
           operand_3
         ]
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
  def parse("minus"), do: {:ok, :-}
  def parse("multiplied"), do: {:ok, :*}
  def parse("divided"), do: {:ok, :div}

  def parse(operator) do
    {:error, :failed_to_parse_operator, operator}
  end
end
