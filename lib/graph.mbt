/// A `Graph` is a graph data structure that stores nodes and edges.
pub struct Graph[X] {
  mut nodes : Array[X]
  mut edges : Array[Array[Double]]
} derive(Show, Debug, Eq)

pub fn Graph::new[X]() -> Graph[X] {
  { nodes: [], edges: [] }
}

/// add_node adds the given node to the graph.
pub fn Graph::add_node[X](self : Graph[X], node : X) -> Unit {
  self.nodes.push(node)
}

/// add_nodes_from adds the given nodes to the graph.
pub fn Graph::add_nodes_from[X](self : Graph[X], nodes : Array[X]) -> Unit {
  nodes.each(fn(node) { self.add_node(node) })
}

/// remove_node removes the node with the given index from the graph and returns it.
pub fn Graph::remove_node[X](self : Graph[X], idx : Int) -> X {
  self.nodes.remove(idx)
}

/// remove_nodes_from removes the nodes with the given indices from the graph and returns them.
pub fn Graph::remove_nodes_from[X](
  self : Graph[X],
  idxs : Array[Int]
) -> Array[X] {
  let removed = []
  idxs.each(fn(idx) { removed.push(self.remove_node(idx)) })
  removed
}

/// add_edge adds an edge from the node with the given index to the node with the given index.
pub fn Graph::add_edge[X](
  self : Graph[X],
  from : Int,
  to : Int,
  ~weight : Double = 1.0
) -> Unit {
  let max = self.nodes.length() - 1
  while self.edges.length() <= max {
    self.edges.push([])
  }
  if self.edges[from].length() <= max {
    self.edges[from].resize(max + 1, 0.0)
  }
  if self.edges[to].length() <= max {
    self.edges[to].resize(max + 1, 0.0)
  }
  self.edges[from][to] = weight
  self.edges[to][from] = weight
}

/// add_edges_from adds the given edges to the graph.
pub fn Graph::add_edges_from[X](
  self : Graph[X],
  edges : Array[(Int, Int)],
  ~weight : Double = 1.0
) -> Unit {
  edges.each(
    fn(edge) {
      let (from, to) = edge
      self.add_edge(from, to, ~weight)
    },
  )
}

/// remove_edge removes the edge from the node with the given index to the node with the given index.
pub fn Graph::remove_edge[X](self : Graph[X], from : Int, to : Int) -> Unit {
  self.edges[from][to] = 0.0
}

/// has_edge returns true if there is an edge from the node with the given index
pub fn Graph::has_edge[X](self : Graph[X], from : Int, to : Int) -> Bool {
  if self.edges.length() <= from {
    false
  } else if self.edges[from].length() <= to {
    false
  } else {
    self.edges[from][to] > 0.0
  }
}

/// get_edges returns the edges in the graph.
pub fn Graph::get_edges[X](self : Graph[X]) -> Array[Array[Double]] {
  self.edges
}

/// get_nodes returns the nodes in the graph.
pub fn Graph::get_nodes[X](self : Graph[X]) -> Array[X] {
  self.nodes
}

/// returns the node at the given index, or None if the index is out of bounds.
pub fn op_get[X](self : Graph[X], idx : Int) -> X? {
  if idx < 0 || idx >= self.nodes.length() {
    None
  } else {
    Some(self.nodes[idx])
  }
}

/// neighbors returns the indices of the neighbors of the node with the given index.
pub fn Graph::neighbors[X](self : Graph[X], idx : Int) -> Array[Int] {
  let neighbors = []
  for i = 0; i < self.edges.length(); i = i + 1 {
    if self.edges[i].length() > idx {
      if self.edges[i][idx] > 0.0 {
        neighbors.push(i)
      }
    }
  }
  neighbors
}

/// edges_from returns the edges that end at the given node.
pub fn Graph::edges_from[X](self : Graph[X], idx : Int) -> Array[(Int, Double)] {
  let edges = []
  for i = 0; i < self.edges.length(); i = i + 1 {
    if self.edges[i].length() > idx {
      if self.edges[i][idx] > 0.0 {
        edges.push((i, self.edges[i][idx]))
      }
    }
  }
  edges
}

/// edges_to returns the edges that start at the given node.
pub fn Graph::edges_to[X](self : Graph[X], idx : Int) -> Array[(Int, Double)] {
  let edges = []
  for i = 0; i < self.edges.length(); i = i + 1 {
    if self.edges[idx].length() > i {
      if self.edges[idx][i] > 0.0 {
        edges.push((i, self.edges[idx][i]))
      }
    }
  }
  edges
}

/// degree returns the degree of the node with the given index.
pub fn Graph::degree[X](self : Graph[X], idx : Int) -> Int {
  let mut degree = 0
  for i = 0; i < self.edges.length(); i = i + 1 {
    if self.edges[i].length() > idx {
      if self.edges[i][idx] > 0.0 {
        degree = degree + 1
      }
    }
  }
  degree
}

/// degrees returns the degree of each node in the graph.
pub fn Graph::degrees[X](self : Graph[X]) -> Array[Int] {
  let degrees = []
  for i = 0; i < self.nodes.length(); i = i + 1 {
    degrees.push(self.degree(i))
  }
  degrees
}

/// is_connected returns true if the graph is connected, false otherwise.
pub fn Graph::is_connected[X](self : Graph[X]) -> Bool {
  let visited = Array::make(self.nodes.length(), false)
  let queue = [0]
  let mut visited_count = 0
  while queue.length() > 0 {
    let current = queue.pop()
    match current {
      Some(current) =>
        if visited[current] == false {
          visited[current] = true
          visited_count = visited_count + 1
          self.neighbors(current).each(
            fn(neighbor) {
              if visited[neighbor] == false {
                queue.push(neighbor)
              }
            },
          )
        }
      None => continue
    }
  }
  visited_count == self.nodes.length()
}

/// is_bipartite returns true if the graph is bipartite, false otherwise.
pub fn Graph::is_bipartite[X](self : Graph[X]) -> Bool {
  let color = Array::make(self.nodes.length(), -1)
  let queue = [0]
  let mut color_count = 2
  while queue.length() > 0 {
    let current = queue.pop()
    match current {
      Some(current) =>
        if color[current] == -1 {
          color[current] = 0
          color_count = color_count - 1
          self.neighbors(current).each(
            fn(neighbor) {
              if color[neighbor] == -1 {
                color[neighbor] = 1 - color[current]
                queue.push(neighbor)
              } else if color[neighbor] == color[current] {
                color_count = 1
                return
              }
            },
          )
        }
      None => continue
    }
  }
  color_count == 0
}

/// is_tree returns true if the graph is a tree, false otherwise.
pub fn Graph::is_tree[X](self : Graph[X]) -> Bool {
  let visited = Array::make(self.nodes.length(), false)
  let queue = [0]
  let mut visited_count = 0
  while queue.length() > 0 {
    let current = queue.pop()
    match current {
      Some(current) =>
        if visited[current] == false {
          visited[current] = true
          visited_count = visited_count + 1
          self.neighbors(current).each(
            fn(neighbor) {
              if visited[neighbor] == false {
                if self.has_edge(current, neighbor) == false {
                  visited_count = 1
                  return
                }
                queue.push(neighbor)
              }
            },
          )
        }
      None => continue
    }
  }
  visited_count == self.nodes.length()
}

/// is_dag returns true if the graph is a directed acyclic graph (DAG), false otherwise.
pub fn Graph::is_dag[X](self : Graph[X]) -> Bool {
  let visited = Array::make(self.nodes.length(), false)
  let queue = [0]
  let mut visited_count = 0
  while queue.length() > 0 {
    let current = queue.pop()
    match current {
      Some(current) =>
        if visited[current] == false {
          visited[current] = true
          visited_count = visited_count + 1
          self.neighbors(current).each(
            fn(neighbor) {
              if visited[neighbor] == false {
                if self.has_edge(current, neighbor) == false {
                  visited_count = 1
                  return
                }
                queue.push(neighbor)
              }
            },
          )
        }
      None => continue
    }
  }
  visited_count == self.nodes.length()
}

/// transitive_closure returns the transitive closure of the graph, i.e., the graph with all transitive edges.
pub fn Graph::transitive_closure[X](self : Graph[X]) -> Graph[X] {
  let closure = Graph::new()
  closure.add_nodes_from(self.nodes)
  for i = 0; i < self.nodes.length(); i = i + 1 {
    for j = 0; j < self.nodes.length(); j = j + 1 {
      if self.has_edge(i, j) {
        closure.add_edge(i, j)
      }
    }
  }
  for k = 0; k < self.nodes.length(); k = k + 1 {
    for i = 0; i < self.nodes.length(); i = i + 1 {
      for j = 0; j < self.nodes.length(); j = j + 1 {
        if closure.has_edge(i, j) && self.has_edge(i, k) && self.has_edge(k, j) {
          closure.add_edge(i, j)
        }
      }
    }
  }
  closure
}

/// reverse returns the reverse of the graph, i.e., the graph with all edges reversed.
pub fn Graph::reverse[X](self : Graph[X]) -> Graph[X] {
  let reversed = Graph::new()
  reversed.add_nodes_from(self.nodes)
  for i = 0; i < self.nodes.length(); i = i + 1 {
    for j = 0; j < self.nodes.length(); j = j + 1 {
      if self.has_edge(i, j) {
        reversed.add_edge(j, i)
      }
    }
  }
  reversed
}

/// subgraph returns the subgraph of the graph with the given nodes.
pub fn Graph::subgraph[X](self : Graph[X], idxs : Array[Int]) -> Graph[X] {
  let sub = Graph::new()
  sub.add_nodes_from(idxs.map(fn(idx) { self.nodes[idx] }))
  for i = 0; i < idxs.length(); i = i + 1 {
    for j = 0; j < idxs.length(); j = j + 1 {
      if self.has_edge(idxs[i], idxs[j]) {
        sub.add_edge(i, j)
      }
    }
  }
  sub
}

/// union returns the union of the two graphs, i.e., the graph with all edges that are in either graph.
pub fn Graph::union[X](self : Graph[X], other : Graph[X]) -> Graph[X] {
  let union = Graph::new()
  union.add_nodes_from(self.nodes)
  union.add_nodes_from(other.nodes)
  for i = 0; i < self.nodes.length(); i = i + 1 {
    for j = 0; j < other.nodes.length(); j = j + 1 {
      if self.has_edge(i, j) || other.has_edge(i, j) {
        union.add_edge(i, j)
      }
    }
  }
  union
}

/// intersection returns the intersection of the two graphs, i.e., the graph with all edges that are in both graphs.
pub fn Graph::intersection[X](self : Graph[X], other : Graph[X]) -> Graph[X] {
  let intersection = Graph::new()
  intersection.add_nodes_from(self.nodes)
  intersection.add_nodes_from(other.nodes)
  for i = 0; i < self.nodes.length(); i = i + 1 {
    for j = 0; j < other.nodes.length(); j = j + 1 {
      if self.has_edge(i, j) && other.has_edge(i, j) {
        intersection.add_edge(i, j)
      }
    }
  }
  intersection
}

/// difference returns the difference of the two graphs, i.e., the graph with all edges that are in the first graph but not in the second.
pub fn Graph::difference[X](self : Graph[X], other : Graph[X]) -> Graph[X] {
  let difference = Graph::new()
  difference.add_nodes_from(self.nodes)
  for i = 0; i < self.nodes.length(); i = i + 1 {
    for j = 0; j < other.nodes.length(); j = j + 1 {
      if self.has_edge(i, j) && other.has_edge(i, j) == false {
        difference.add_edge(i, j)
      }
    }
  }
  difference
}

/// symmetric_difference returns the symmetric difference of the two graphs, i.e., the graph with all edges that are in either graph but not both.
pub fn Graph::symmetric_difference[X](
  self : Graph[X],
  other : Graph[X]
) -> Graph[X] {
  let symmetric_difference = Graph::new()
  symmetric_difference.add_nodes_from(self.nodes)
  symmetric_difference.add_nodes_from(other.nodes)
  for i = 0; i < self.nodes.length(); i = i + 1 {
    for j = 0; j < other.nodes.length(); j = j + 1 {
      if self.has_edge(i, j) && other.has_edge(i, j) == false {
        symmetric_difference.add_edge(i, j)
      } else if self.has_edge(i, j) == false && other.has_edge(i, j) {
        symmetric_difference.add_edge(i, j)
      }
    }
  }
  symmetric_difference
}

/// complement returns the complement of the graph, i.e., the graph with all edges reversed.
pub fn Graph::complement[X](self : Graph[X]) -> Graph[X] {
  let complement = Graph::new()
  complement.add_nodes_from(self.nodes)
  for i = 0; i < self.nodes.length(); i = i + 1 {
    for j = 0; j < self.nodes.length(); j = j + 1 {
      if i != j && self.has_edge(i, j) == false {
        complement.add_edge(i, j)
      }
    }
  }
  complement
}

/// to_dot converts a graph to a dot format string.
pub fn Graph::to_dot[X](self : Graph[X]) -> String {
  let mut dot = "graph G {\n"
  for i = 0; i < self.nodes.length(); i = i + 1 {
    dot = dot + "  " + i.to_string() + ";\n"
    for j = 0; j < self.nodes.length(); j = j + 1 {
      if self.has_edge(i, j) {
        dot = dot + "  " + i.to_string() + " -- " + j.to_string() + ";\n"
      }
    }
  }
  dot = dot + "}\n"
  dot
}

pub fn Graph::dijkstra_path[X](
  self : Graph[X],
  start : Int,
  end : Int
) -> Array[Int]? {
  let dist = Array::make(self.nodes.length(), @double.inf(1))
  let prev = Array::make(self.nodes.length(), 0)
  dist[start] = 0.0
  let queue = [start]
  while queue.length() > 0 {
    let current = queue.pop()
    match current {
      Some(current) =>
        self.neighbors(current).each(
          fn(neighbor) {
            let alt = dist[current] + self.edges[current][neighbor]
            if alt < dist[neighbor] {
              dist[neighbor] = alt
              prev[neighbor] = current
              queue.push(neighbor)
            }
          },
        )
      None => continue
    }
  }
  if @double.is_pos_inf(dist[end]) {
    None
  } else {
    let path = [end]
    let mut current = end
    while prev[current] != 0 {
      path.push(current)
      current = prev[current]
    }
    
    Some(path.rev())
  }
}
