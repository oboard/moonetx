///| A `DiGraph` is a directed graph with nodes of type `X` and edges of type `Double`.
pub struct DiGraph[X] {
  nodes : Array[X]
  edges : Array[Array[Double]]
} derive(Show, Eq)

///| Creates a new, empty graph.
pub fn[X] DiGraph::new() -> DiGraph[X] {
  { nodes: [], edges: [] }
}

///| Adds a node to the graph.
pub fn[X] DiGraph::add_node(self : DiGraph[X], node : X) -> Unit {
  self.nodes.push(node)
}

///| Adds a list of nodes to the graph.
pub fn[X] DiGraph::add_nodes_from(self : DiGraph[X], nodes : Array[X]) -> Unit {
  nodes.each(fn(node) { self.add_node(node) })
}

///| Removes a node from the graph and returns it.
pub fn[X] DiGraph::remove_node(self : DiGraph[X], idx : Int) -> X {
  self.nodes.remove(idx)
}

///| Removes a list of nodes from the graph.
pub fn[X] DiGraph::remove_nodes_from(
  self : DiGraph[X],
  idxs : Array[Int]
) -> Array[X] {
  let removed = []
  idxs.each(fn(idx) { removed.push(self.remove_node(idx)) })
  removed
}

///| Adds an edge to the graph.
pub fn[X] DiGraph::add_edge(
  self : DiGraph[X],
  from : Int,
  to : Int,
  weight~ : Double = 1.0
) -> Unit {
  while self.edges.length() <= from {
    self.edges.push([])
  }
  if self.edges[from].length() <= to {
    self.edges[from].resize(to + 1, 0.0)
  }
  self.edges[from][to] = weight
}

///| Adds a list of edges to the graph.
pub fn[X] DiGraph::add_edges_from(
  self : DiGraph[X],
  edges : Array[(Int, Int)],
  weight~ : Double = 1.0
) -> Unit {
  edges.each(fn(edge) {
    let (from, to) = edge
    while self.edges.length() <= from {
      self.edges.push([])
    }
    if self.edges[from].length() <= to {
      self.edges[from].resize(to + 1, 0.0)
    }
    self.edges[from][to] = weight
  })
}

///| Removes the edge from `from` to `to` if it exists.
pub fn[X] DiGraph::remove_edge(self : DiGraph[X], from : Int, to : Int) -> Unit {
  self.edges[from][to] = 0.0
}

///| Returns true if the graph has an edge from `from` to `to`, false otherwise.
pub fn[X] DiGraph::has_edge(self : DiGraph[X], from : Int, to : Int) -> Bool {
  if self.edges.length() <= from {
    false
  } else if self.edges[from].length() <= to {
    false
  } else {
    self.edges[from][to] > 0.0
  }
}

///| Returns a list of edges in the graph.
pub fn[X] DiGraph::get_edges(self : DiGraph[X]) -> Array[Array[Double]] {
  self.edges
}

///| Returns a list of nodes in the graph.
pub fn[X] DiGraph::get_nodes(self : DiGraph[X]) -> Array[X] {
  self.nodes
}

///| Returns the number of nodes in the graph.
pub fn[X] DiGraph::op_get(self : DiGraph[X], idx : Int) -> X? {
  if idx < 0 || idx >= self.nodes.length() {
    None
  } else {
    Some(self.nodes[idx])
  }
}

///| Returns a list of neighbors of the given node.
pub fn[X] DiGraph::neighbors(self : DiGraph[X], idx : Int) -> Array[Int] {
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

///| Returns a list of edges from the given node to other nodes.
pub fn[X] DiGraph::edges_from(
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

///| Returns a list of edges from the given node to other nodes.
pub fn[X] DiGraph::edges_to(
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

///| Returns the degree of the given node.
pub fn[X] DiGraph::degree(self : DiGraph[X], idx : Int) -> Int {
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

///| Returns the in-degree of the given node.
pub fn[X] DiGraph::in_degree(self : DiGraph[X], idx : Int) -> Int {
  let mut degree = 0
  self.edges[idx].each(fn(weight) { if weight > 0.0 { degree = degree + 1 } })
  degree
}

///| Returns the out-degree of the given node.
pub fn[X] DiGraph::out_degree(self : DiGraph[X], idx : Int) -> Int {
  let mut degree = 0
  self.edges.each(fn(row) {
    if row.length() > idx {
      if row[idx] > 0.0 {
        degree = degree + 1
      }
    }
  })
  degree
}

///| Returns a list of degrees of all nodes in the graph.
pub fn[X] DiGraph::degrees(self : DiGraph[X]) -> Array[Int] {
  let degrees = []
  for i = 0; i < self.nodes.length(); i = i + 1 {
    degrees.push(self.degree(i))
  }
  degrees
}

///| Returns a list of predecessors of the given node.
pub fn[X] DiGraph::predecessors(self : DiGraph[X], idx : Int) -> Array[Int] {
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

///| Returns a list of successors of the given node.
pub fn[X] DiGraph::successors(self : DiGraph[X], idx : Int) -> Array[Int] {
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

///| Returns true if the graph is weighted, false otherwise.
pub fn[X] DiGraph::is_weighted(self : DiGraph[X]) -> Bool {
  for i = 0; i < self.edges.length(); i = i + 1 {
    for j = 0; j < self.edges[i].length(); j = j + 1 {
      if self.edges[i][j] != 1.0 {
        return true
      }
    }
  }
  false
}

///| Returns true if the graph is a tree, false otherwise.
pub fn[X] DiGraph::is_complete(self : DiGraph[X]) -> Bool {
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

///| Returns true if the graph is acyclic, false otherwise.
pub fn[X] DiGraph::is_cyclic(self : DiGraph[X]) -> Bool {
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
          self
          .neighbors(current)
          .each(fn(neighbor) {
            if visited[neighbor] == false {
              queue.push(neighbor)
            }
          })
        }
      None => continue
    }
  }
  visited_count != self.nodes.length()
}

///| Returns true if the graph is strongly connected, false otherwise.
pub fn[X] DiGraph::is_strongly_connected(self : DiGraph[X]) -> Bool {
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
          self
          .neighbors(current)
          .each(fn(neighbor) {
            if visited[neighbor] == false {
              queue.push(neighbor)
            }
          })
        }
      None => continue
    }
  }
  visited_count == self.nodes.length()
}

///| Returns true if the graph is eulerian, false otherwise.
pub fn[X] DiGraph::is_eulerian(self : DiGraph[X]) -> Bool {
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

///|
pub fn[X] DiGraph::is_connected(self : DiGraph[X]) -> Bool {
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
          self
          .neighbors(current)
          .each(fn(neighbor) {
            if visited[neighbor] == false {
              queue.push(neighbor)
            }
          })
        }
      None => continue
    }
  }
  visited_count == self.nodes.length()
}

///|
pub fn[X] DiGraph::is_bipartite(self : DiGraph[X]) -> Bool {
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
          self
          .neighbors(current)
          .each(fn(neighbor) {
            if color[neighbor] == -1 {
              color[neighbor] = 1 - color[current]
              queue.push(neighbor)
            } else if color[neighbor] == color[current] {
              color_count = 1
              return
            }
          })
        }
      None => continue
    }
  }
  color_count == 0
}

///|
pub fn[X] DiGraph::is_tree(self : DiGraph[X]) -> Bool {
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
          self
          .neighbors(current)
          .each(fn(neighbor) {
            if visited[neighbor] == false {
              if self.has_edge(current, neighbor) == false {
                visited_count = 1
                return
              }
              queue.push(neighbor)
            }
          })
        }
      None => continue
    }
  }
  visited_count == self.nodes.length()
}

///|
pub fn[X] DiGraph::is_dag(self : DiGraph[X]) -> Bool {
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
          self
          .neighbors(current)
          .each(fn(neighbor) {
            if visited[neighbor] == false {
              if self.has_edge(current, neighbor) == false {
                visited_count = 1
                return
              }
              queue.push(neighbor)
            }
          })
        }
      None => continue
    }
  }
  visited_count == self.nodes.length()
}

///|
pub fn[X] DiGraph::transitive_closure(self : DiGraph[X]) -> DiGraph[X] {
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

///|
pub fn[X] DiGraph::reverse(self : DiGraph[X]) -> DiGraph[X] {
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

///|
pub fn[X] DiGraph::subDiGraph(
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

///|
pub fn[X] DiGraph::union(self : DiGraph[X], other : DiGraph[X]) -> DiGraph[X] {
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

///|
pub fn[X] DiGraph::intersection(
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

///|
pub fn[X] DiGraph::difference(
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

///|
pub fn[X] DiGraph::symmetric_difference(
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

///|
pub fn[X] DiGraph::complement(self : DiGraph[X]) -> DiGraph[X] {
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

///|
pub fn[X] DiGraph::to_dot(self : DiGraph[X]) -> String {
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

///| single_source_dijkstra 返回从 source 到所有其他节点的最短路径，使用 Dijkstra 算法。
pub fn[X] DiGraph::single_source_dijkstra(
  self : DiGraph[X],
  source~ : Int
) -> (Array[Double], Array[Array[Int]]) {
  // dist, paths
  // 检查起点和终点是否合法
  if source < 0 || source >= self.nodes.length() {
    return (
      Array::make(self.nodes.length(), @double.infinity),
      Array::make(self.nodes.length(), []),
    )
  }
  let dist = Array::make(self.nodes.length(), @double.infinity)
  let visited = Array::make(self.nodes.length(), false)
  let parent = Array::make(self.nodes.length(), -1)
  dist[source] = 0.0
  for i in 0..<self.nodes.length() {
    fn min_distance(dist : Array[Double], visited : Array[Bool]) -> Int {
      let mut min_dist = @double.infinity
      let mut min_index = -1
      for j in 0..<dist.length() {
        if visited[j] == false && dist[j] <= min_dist {
          min_dist = dist[j]
          min_index = j
        }
      }
      min_index
    }

    let u = min_distance(dist, visited)
    if u == -1 {
      break
    }
    visited[u] = true
    for v in 0..<self.nodes.length() {
      if self.has_edge(u, v) &&
        visited[v] == false &&
        dist[u] != @double.infinity &&
        dist[u] + self.edges[u][v] < dist[v] {
        dist[v] = dist[u] + self.edges[u][v]
        parent[v] = u
      }
    }
  }
  // 构建每个节点的最短路径
  let paths = Array::make(self.nodes.length(), [])
  for i in 0..<self.nodes.length() {
    let path = []
    let mut current = i
    if dist[i] == @double.infinity {
      // 不可达，留空
      paths[i] = []
      continue
    }
    while current != -1 {
      path.insert(0, current)
      if current == source {
        break
      }
      current = parent[current]
    }
    paths[i] = path
  }
  (dist, paths)
}
