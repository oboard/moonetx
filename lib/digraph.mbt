/// A `DiGraph` is a directed graph with nodes of type `X` and edges of type `Double`.
pub struct DiGraph[X] {
  mut nodes : Array[X]
  mut edges : Array[Array[Double]]
} derive(Show, Eq)

/// Creates a new, empty graph.
pub fn DiGraph::new[X]() -> DiGraph[X] {
  { nodes: [], edges: [] }
}

/// Adds a node to the graph.
pub fn DiGraph::add_node[X](self : DiGraph[X], node : X) -> Unit {
  self.nodes.push(node)
}

/// Adds a list of nodes to the graph.
pub fn DiGraph::add_nodes_from[X](self : DiGraph[X], nodes : Array[X]) -> Unit {
  nodes.each(fn(node) { self.add_node(node) })
}

/// Removes a node from the graph and returns it.
pub fn DiGraph::remove_node[X](self : DiGraph[X], idx : Int) -> X {
  self.nodes.remove(idx)
}

/// Removes a list of nodes from the graph.
pub fn DiGraph::remove_nodes_from[X](
  self : DiGraph[X],
  idxs : Array[Int]
) -> Array[X] {
  let removed = []
  idxs.each(fn(idx) { removed.push(self.remove_node(idx)) })
  removed
}

/// Adds an edge to the graph.
pub fn DiGraph::add_edge[X](
  self : DiGraph[X],
  from : Int,
  to : Int,
  ~weight : Double = 1.0
) -> Unit {
  while self.edges.length() <= from {
    self.edges.push([])
  }
  if self.edges[from].length() <= to {
    self.edges[from].resize(to + 1, 0.0)
  }
  self.edges[from][to] = weight
}

/// Adds a list of edges to the graph.
pub fn DiGraph::add_edges_from[X](
  self : DiGraph[X],
  edges : Array[(Int, Int)],
  ~weight : Double = 1.0
) -> Unit {
  edges.each(
    fn(edge) {
      let (from, to) = edge
      while self.edges.length() <= from {
        self.edges.push([])
      }
      if self.edges[from].length() <= to {
        self.edges[from].resize(to + 1, 0.0)
      }
      self.edges[from][to] = weight
    },
  )
}

/// Removes the edge from `from` to `to` if it exists.
pub fn DiGraph::remove_edge[X](self : DiGraph[X], from : Int, to : Int) -> Unit {
  self.edges[from][to] = 0.0
}

/// Returns true if the graph has an edge from `from` to `to`, false otherwise.
pub fn DiGraph::has_edge[X](self : DiGraph[X], from : Int, to : Int) -> Bool {
  if self.edges.length() <= from {
    false
  } else if self.edges[from].length() <= to {
    false
  } else {
    self.edges[from][to] > 0.0
  }
}

/// Returns a list of edges in the graph.
pub fn DiGraph::get_edges[X](self : DiGraph[X]) -> Array[Array[Double]] {
  self.edges
}

/// Returns a list of nodes in the graph.
pub fn DiGraph::get_nodes[X](self : DiGraph[X]) -> Array[X] {
  self.nodes
}

/// Returns the number of nodes in the graph.
pub fn op_get[X](self : DiGraph[X], idx : Int) -> X? {
  if idx < 0 || idx >= self.nodes.length() {
    None
  } else {
    Some(self.nodes[idx])
  }
}

/// Returns a list of neighbors of the given node.
pub fn DiGraph::neighbors[X](self : DiGraph[X], idx : Int) -> Array[Int] {
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

/// Returns a list of edges from the given node to other nodes.
pub fn DiGraph::edges_from[X](
  self : DiGraph[X],
  idx : Int
) -> Array[(Int, Double)] {
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

/// Returns a list of edges from the given node to other nodes.
pub fn DiGraph::edges_to[X](
  self : DiGraph[X],
  idx : Int
) -> Array[(Int, Double)] {
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

/// Returns the degree of the given node.
pub fn DiGraph::degree[X](self : DiGraph[X], idx : Int) -> Int {
  let mut degree = 0
  for i = 0; i < self.edges.length(); i = i + 1 {
    if self.edges[i].length() > idx {
      if self.edges[i][idx] > 0.0 {
        degree = degree + 1
      }
    }
    if self.edges[idx].length() > i {
      if self.edges[idx][i] > 0.0 {
        degree = degree + 1
      }
    }
  }
  degree
}

/// Returns the in-degree of the given node.
pub fn DiGraph::in_degree[X](self : DiGraph[X], idx : Int) -> Int {
  let mut degree = 0
  self.edges[idx].each(fn(weight) { if weight > 0.0 { degree = degree + 1 } })
  degree
}

/// Returns the out-degree of the given node.
pub fn DiGraph::out_degree[X](self : DiGraph[X], idx : Int) -> Int {
  let mut degree = 0
  self.edges.each(
    fn(row) {
      if row.length() > idx {
        if row[idx] > 0.0 {
          degree = degree + 1
        }
      }
    },
  )
  degree
}

/// Returns a list of degrees of all nodes in the graph.
pub fn DiGraph::degrees[X](self : DiGraph[X]) -> Array[Int] {
  let degrees = []
  for i = 0; i < self.nodes.length(); i = i + 1 {
    degrees.push(self.degree(i))
  }
  degrees
}

/// Returns a list of predecessors of the given node.
pub fn DiGraph::predecessors[X](self : DiGraph[X], idx : Int) -> Array[Int] {
  let predecessors = []
  for i = 0; i < self.edges.length(); i = i + 1 {
    if self.edges[i].length() > idx {
      if self.edges[i][idx] > 0.0 {
        predecessors.push(i)
      }
    }
  }
  predecessors
}

/// Returns a list of successors of the given node.
pub fn DiGraph::successors[X](self : DiGraph[X], idx : Int) -> Array[Int] {
  let successors = []
  for i = 0; i < self.edges.length(); i = i + 1 {
    if self.edges[idx].length() > i {
      if self.edges[idx][i] > 0.0 {
        successors.push(i)
      }
    }
  }
  successors
}

/// Returns true if the graph is weighted, false otherwise.
pub fn DiGraph::is_weighted[X](self : DiGraph[X]) -> Bool {
  for i = 0; i < self.edges.length(); i = i + 1 {
    for j = 0; j < self.edges[i].length(); j = j + 1 {
      if self.edges[i][j] != 1.0 {
        return true
      }
    }
  }
  false
}

/// Returns true if the graph is a tree, false otherwise.
pub fn DiGraph::is_complete[X](self : DiGraph[X]) -> Bool {
  for i = 0; i < self.edges.length(); i = i + 1 {
    for j = 0; j < self.edges[i].length(); j = j + 1 {
      if self.edges[i][j] != 1.0 {
        return false
      }
    }
  }
  for i = 0; i < self.edges.length(); i = i + 1 {
    for j = i + 1; j < self.edges.length(); j = j + 1 {
      if self.edges[i][j] != 1.0 {
        return false
      }
    }
  }
  true
}

/// Returns true if the graph is acyclic, false otherwise.
pub fn DiGraph::is_cyclic[X](self : DiGraph[X]) -> Bool {
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
  visited_count != self.nodes.length()
}

/// Returns true if the graph is strongly connected, false otherwise.
pub fn DiGraph::is_strongly_connected[X](self : DiGraph[X]) -> Bool {
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

/// Returns true if the graph is eulerian, false otherwise.
pub fn DiGraph::is_eulerian[X](self : DiGraph[X]) -> Bool {
  let mut odd_degree_count = 0
  for i = 0; i < self.nodes.length(); i = i + 1 {
    if self.degree(i) % 2 == 1 {
      odd_degree_count = odd_degree_count + 1
    }
  }
  if odd_degree_count > 2 {
    false
  } else {
    let odd_degree_nodes = []
    for i = 0; i < self.nodes.length(); i = i + 1 {
      if self.degree(i) % 2 == 1 {
        odd_degree_nodes.push(i)
      }
    }
    if odd_degree_count == 0 {
      true
    } else if odd_degree_count == 1 {
      let odd_degree_node = odd_degree_nodes[0]
      self.degree(odd_degree_node) == 1
    } else {
      let odd_degree_node1 = odd_degree_nodes[0]
      let odd_degree_node2 = odd_degree_nodes[1]
      self.degree(odd_degree_node1) == 1 && self.degree(odd_degree_node2) == 1
    }
  }
}

pub fn DiGraph::is_connected[X](self : DiGraph[X]) -> Bool {
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

pub fn DiGraph::is_bipartite[X](self : DiGraph[X]) -> Bool {
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

pub fn DiGraph::is_tree[X](self : DiGraph[X]) -> Bool {
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

pub fn DiGraph::is_dag[X](self : DiGraph[X]) -> Bool {
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

pub fn DiGraph::transitive_closure[X](self : DiGraph[X]) -> DiGraph[X] {
  let closure = DiGraph::new()
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

pub fn DiGraph::reverse[X](self : DiGraph[X]) -> DiGraph[X] {
  let reversed = DiGraph::new()
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

pub fn DiGraph::subDiGraph[X](
  self : DiGraph[X],
  idxs : Array[Int]
) -> DiGraph[X] {
  let sub = DiGraph::new()
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

pub fn DiGraph::union[X](self : DiGraph[X], other : DiGraph[X]) -> DiGraph[X] {
  let union = DiGraph::new()
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

pub fn DiGraph::intersection[X](
  self : DiGraph[X],
  other : DiGraph[X]
) -> DiGraph[X] {
  let intersection = DiGraph::new()
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

pub fn DiGraph::difference[X](
  self : DiGraph[X],
  other : DiGraph[X]
) -> DiGraph[X] {
  let difference = DiGraph::new()
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

pub fn DiGraph::symmetric_difference[X](
  self : DiGraph[X],
  other : DiGraph[X]
) -> DiGraph[X] {
  let symmetric_difference = DiGraph::new()
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

pub fn DiGraph::complement[X](self : DiGraph[X]) -> DiGraph[X] {
  let complement = DiGraph::new()
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

pub fn DiGraph::to_dot[X](self : DiGraph[X]) -> String {
  let mut dot = "diDiGraph G {\n"
  for i = 0; i < self.nodes.length(); i = i + 1 {
    dot = dot + "  " + i.to_string() + ";\n"
  }
  for i = 0; i < self.nodes.length(); i = i + 1 {
    for j = 0; j < self.nodes.length(); j = j + 1 {
      if self.has_edge(i, j) {
        dot = dot + "  " + i.to_string() + " -> " + j.to_string() + ";\n"
      }
    }
  }
  dot = dot + "}\n"
  dot
}

pub fn DiGraph::dijkstra_path[X](
  self : DiGraph[X],
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
