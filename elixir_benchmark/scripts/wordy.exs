Code.load_file("wordy.exs", "../elixir/wordy")
single_addition = "What is 1 plus 1?"
double_division = "What is -12 divided by 2 divided by -3?"

Benchee.run(%{
  "wordy_single_addition" => fn -> Wordy.answer(single_addition) end,
  "wordy_double_division" => fn -> Wordy.answer(double_division) end
})
