Code.load_file("queen_attack.exs", "../elixir/queen-attack")

Benchee.run(
  %{
    "new/0" => fn -> Queens.new() end,
    "new/2" => fn -> Queens.new({3, 7}, {6, 1}) end
  },
  print: [fast_warning: false]
)
