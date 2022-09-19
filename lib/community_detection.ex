defmodule CommunityDetection do
  alias Helpers.Comb

  @moduledoc """
  Documentation for `CommunityDetection`.
  build_communities/2 finds the edge betweeness centrality of
  nodes and removes the highest ranking one, and repeats this num_iterations times.
  """

  # Graph.to_dot(graph) # https://www.graphviz.org/
  # Girvan-Newman Algorithm
  # use num_iterations or edge_betweenness threshold?
  # get edge_betweenness for each in list
  # sort list from highest to lowest edge_betweeness values
  # delete edges with high edge_betweeness values
  def build_communities(graph, num_iterations) do
    Enum.reduce(1..num_iterations, graph, fn _i, acc -> remove_edge_with_highest_betweeness(acc) end)
    # find connected components?
    # clusters where all vertices have > 1 edge?
    # Graph.to_dot(graph) # https://www.graphviz.org/
    # Graph.strong_components(graph)
  end

  def remove_edge_with_highest_betweeness(graph) do
    {edge_to_remove, _count} = edge_with_highest_betweeness(graph)
    ## IO.inspect({edge_to_remove, _count})
    Graph.delete_edge(graph, edge_to_remove.v1, edge_to_remove.v2)
  end

  def edge_with_highest_betweeness(graph) do
    graph
    |> edge_betweenness_centrality()
    |> Enum.at(0)
  end

  def edge_betweenness_centrality(graph, _unidirectional \\ false) do
    # order edges by highest number of shortest paths that pass through them
    graph
    |> Graph.vertices()
    |> get_routes(graph)
    |> Enum.map(fn {v1, v2} -> Graph.dijkstra(graph, v1, v2) end)
    |> Enum.filter(fn path -> is_list(path) end)
    |> Enum.map(fn path -> get_edges(graph, path) end)
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.sort(fn {_, count_1}, {_, count_2} -> count_1 >= count_2 end) # sort highest to lowest
  end

  def get_routes(vertices, %Graph{type: :undirected}), do: Comb.combinations(vertices)
  def get_routes(vertices, %Graph{type: :directed}), do: Comb.permutations(vertices)

  def get_edges(graph, nil), do: nil
  def get_edges(graph, path) do
    path
    |> Enum.chunk_every(2, 1, :discard) # create edge pairs (sets of connections)
    |> Enum.map(fn [v1, v2] ->
      Graph.edge(graph, v1, v2)
    end)
  end

end
