defmodule CommunityDetectionTest do
  use ExUnit.Case
  doctest CommunityDetection

  @graph [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
  @edges [
    {1, 2}, {2, 3}, {1, 3}, {1, 4},
    {1, 5}, {3, 5}, {6, 7}, {7, 8},
    {8, 9}, {6, 9}, {6, 8}, {7, 9},
    {10, 11}, {11, 12}, {10, 12},
    {9, 12}, {2, 7}
  ]

  # CommunityDetection.test
  # # Enum.each(x, fn v -> IO.inspect("#{v}") end)
  def community_detection_test(graph, edges, type \\ :undirected) do
    graph =
      Graph.new()
      |> Graph.add_vertices(graph)
      |> Graph.add_edges(edges)
      |> Map.put(:type, type)

    CommunityDetection.build_communities(graph, 3)
  end

  describe "Community Detection" do
    test "directed graph" do
      directed_result = community_detection_test(@graph, @edges, :directed)
      assert directed_result != nil
    end

    test "un-directed graph" do
      directed_result = community_detection_test(@graph, @edges, :directed)
      assert directed_result != nil
      undirected_result = community_detection_test(@graph, @edges, :undirected)
      assert undirected_result != nil
    end
  end
end
