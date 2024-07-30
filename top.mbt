fn find_neighbors() -> Array[Int] {
  let graph = @nx.Graph::new()
  graph.add_nodes_from([0, 1, 2, 3, 4, 5])
  graph.add_edges_from([(1, 2), (2, 5)])
  println(graph)
  graph.neighbors(2)
}

fn get_in_degree() -> Int {
  let graph = @nx.DiGraph::new()
  graph.add_nodes_from([0, 1, 2, 3, 4, 5])
  graph.add_edges_from([(1, 2), (2, 5)])
  println(graph)
  graph.out_degree(2)
}

test {
  inspect!(find_neighbors(), content="[1, 5]")
  inspect!(get_in_degree(), content="1")
}
