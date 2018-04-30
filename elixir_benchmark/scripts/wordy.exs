Code.load_file("wordy.exs", "../elixir/wordy")
require Integer

operation = fn -> Enum.random(["divided by", "multiplied by", "minus", "plus"]) end
operand = fn -> Enum.random(1..1_000_000) end

big_expression =
  for x <- 1..100_001 do
    if Integer.is_even(x) do
      operation.()
    else
      operand.()
    end
  end

big_expression = "What is #{Enum.join(big_expression, " ")}?"

Wordy.answer(big_expression)

Benchee.run(%{
  "wordy_big_expression" => fn -> Wordy.answer(big_expression) end
})
