Code.load_file("queen_attack.exs", "../elixir/queen-attack")

queens = Queens.new({4, 3}, {2, 7})

Benchee.run(
  %{
    "new/0" => fn -> Queens.new() end,
    "new/2" => fn -> Queens.new({4, 3}, {2, 7}) end,
    "to_string/1" => fn -> Queens.to_string(queens) end,
    "can_attack?/1" => fn -> Queens.can_attack?(queens) end
  },
  print: [fast_warning: false]
)
