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
    |> parse_operations()
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
  
  defp parse_operations(operations, operation_struct \\ %Operation{operator: nil, operands: []})
  defp parse_operations([operand, operator |rest] = operations, operation_struct) do
    with {:ok, parsed_operand} <- Operand.parse(operand),
         {:ok, parsed_operator} <- Operator.parse(operator)
    do
      if operation_struct.operator && length(operation_struct.operands)==1 do
        new_operation_struct = %{operation_struct | operands: operation_struct.operands ++ [parsed_operand]}
        new_operand = execute(new_operation_struct)
        parse_operations(rest, %Operation{operands: [new_operand], operator: parsed_operator})
      else
        new_operation_struct = %{operation_struct | operands: operation_struct.operands ++ [parsed_operand], operator: parsed_operator}
        parse_operations(rest, new_operation_struct)
      end
    else
      _ -> raise ArgumentError
    end
  end
  defp parse_operations([operand], operation_struct) do
    case Operand.parse(operand) do
      {:ok, verified} -> 
        {:ok, %{operation_struct | operands: operation_struct.operands ++ [verified]}}
      anything -> anything
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
