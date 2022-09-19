defmodule Helpers.Comb do
  def combinations([]), do: []
  def combinations([head | tail]) do
    sets = Enum.map(tail, fn v2 -> {head, v2} end)
    sets ++ combinations(tail)
  end

  def permutations([]), do: []
  def permutations([head | tail]) do
    sets = Enum.reduce(tail, [], fn v2, acc ->
      acc = [{head, v2}| acc]
      [{v2, head}| acc]
    end)

    sets ++ permutations(tail)
  end
end
