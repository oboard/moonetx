///| A `Graph` is a graph data structure that stores nodes and edges.
pub struct Graph[X] {
  nodes : Array[X]
  edges : Array[Array[Double]]
} derive(Show, Eq)

///|
pub fn[X] Graph::new() -> Graph[X] {
  { nodes: [], edges: [] }
}

///| add_node adds the given node to the graph.
pub fn[X] Graph::add_node(self : Graph[X], node : X) -> Unit {
  self.nodes.push(node)
}

///| add_nodes_from adds the given nodes to the graph.
pub fn[X] Graph::add_nodes_from(self : Graph[X], nodes : Array[X]) -> Unit {
  nodes.each(fn(node) { self.add_node(node) })
}

///| remove_node removes the node with the given index from the graph and returns it.
pub fn[X] Graph::remove_node(self : Graph[X], idx : Int) -> X {
  self.nodes.remove(idx)
}

///| remove_nodes_from removes the nodes with the given indices from the graph and returns them.
pub fn[X] Graph::remove_nodes_from(
  self : Graph[X],
  idxs : Array[Int]
) -> Array[X] {
  let removed = []
  idxs.each(fn(idx) { removed.push(self.remove_node(idx)) })
  removed
}

///| add_edge adds an edge from the node with the given index to the node with the given index.
pub fn[X] Graph::add_edge(
  self : Graph[X],
  from : Int,
  to : Int,
  weight~ : Double = 1.0
) -> Unit {
  let max = self.nodes.length() - 1
  while self.edges.length() <= max {
    self.edges.push([])
  }
  if self.edges[from].length() <= max {
    self.edges[from].resize(max + 1, @double.infinity)
  }
  if self.edges[to].length() <= max {
    self.edges[to].resize(max + 1, @double.infinity)
  }
  self.edges[from][to] = weight
  self.edges[to][from] = weight
}

///| add_edges_from adds the given edges to the graph.
pub fn[X] Graph::add_edges_from(
  self : Graph[X],
  edges : Array[(Int, Int)],
  weight~ : Double = 1.0
) -> Unit {
  edges.each(fn(edge) {
    let (from, to) = edge
    self.add_edge(from, to, weight~)
  })
}

///| add_weighted_edges_from adds the given weighted edges to the graph.
pub fn[X] Graph::add_weighted_edges_from(
  self : Graph[X],
  edges : Array[(Int, Int, Double)]
) -> Unit {
  edges.each(fn(edge) {
    let (from, to, weight) = edge
    self.add_edge(from, to, weight~)
  })
}

///| remove_edge removes the edge from the node with the given index to the node with the given index.
pub fn[X] Graph::remove_edge(self : Graph[X], from : Int, to : Int) -> Unit {
  self.edges[from][to] = @double.infinity
}

///| has_edge returns true if there is an edge from the node with the given index
pub fn[X] Graph::has_edge(self : Graph[X], from : Int, to : Int) -> Bool {
  if self.edges.length() <= from {
    false
  } else if self.edges[from].length() <= to {
    false
  } else {
    self.edges[from][to] < @double.infinity
  }
}

///|
pub fn[X : Eq] Graph::has_node(self : Graph[X], x : X) -> Bool {
  !self.nodes.search(x).is_empty()
}

///| get_edges returns the edges in the graph.
pub fn[X] Graph::get_edges(self : Graph[X]) -> Array[Array[Double]] {
  self.edges
}

///| get_nodes returns the nodes in the graph.
pub fn[X] Graph::get_nodes(self : Graph[X]) -> Array[X] {
  self.nodes
}

///| returns the node at the given index, or None if the index is out of bounds.
pub fn[X] op_get(self : Graph[X], idx : Int) -> X? {
  if idx < 0 || idx >= self.nodes.length() {
    None
  } else {
    Some(self.nodes[idx])
  }
}

///| neighbors returns the indices of the neighbors of the node with the given index.
pub fn[X] Graph::neighbors(self : Graph[X], idx : Int) -> Array[Int] {
  let neighbors = []
  for i = 0; i < self.edges.length(); i = i + 1 {
    if self.edges[i].length() > idx {
      if self.edges[i][idx] < @double.infinity {
        neighbors.push(i)
      }
    }
  }
  neighbors
}

///| edges_from returns the edges that end at the given node.
pub fn[X] Graph::edges_from(self : Graph[X], idx : Int) -> Array[(Int, Double)] {
  let edges = []
  for i = 0; i < self.edges.length(); i = i + 1 {
    if self.edges[i].length() > idx {
      if self.edges[i][idx] < @double.infinity {
        edges.push((i, self.edges[i][idx]))
      }
    }
  }
  edges
}

///| edges_to returns the edges that start at the given node.
pub fn[X] Graph::edges_to(self : Graph[X], idx : Int) -> Array[(Int, Double)] {
  let edges = []
  for i = 0; i < self.edges.length(); i = i + 1 {
    if self.edges[idx].length() > i {
      if self.edges[idx][i] < @double.infinity {
        edges.push((i, self.edges[idx][i]))
      }
    }
  }
  edges
}

///| degree returns the degree of the node with the given index.
pub fn[X] Graph::degree(self : Graph[X], idx : Int) -> Int {
  let mut degree = 0
  for i = 0; i < self.edges.length(); i = i + 1 {
    if self.edges[i].length() > idx {
      if self.edges[i][idx] < @double.infinity {
        degree = degree + 1
      }
    }
  }
  degree
}

///| degrees returns the degree of each node in the graph.
pub fn[X] Graph::degrees(self : Graph[X]) -> Array[Int] {
  let degrees = []
  for i = 0; i < self.nodes.length(); i = i + 1 {
    degrees.push(self.degree(i))
  }
  degrees
}

///| is_connected returns true if the graph is connected, false otherwise.
pub fn[X] Graph::is_connected(self : Graph[X]) -> Bool {
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

///| is_bipartite returns true if the graph is bipartite, false otherwise.
pub fn[X] Graph::is_bipartite(self : Graph[X]) -> Bool {
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

///| is_tree returns true if the graph is a tree, false otherwise.
pub fn[X] Graph::is_tree(self : Graph[X]) -> Bool {
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

///| is_dag returns true if the graph is a directed acyclic graph (DAG), false otherwise.
pub fn[X] Graph::is_dag(self : Graph[X]) -> Bool {
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

///| transitive_closure returns the transitive closure of the graph, i.e., the graph with all transitive edges.
pub fn[X] Graph::transitive_closure(self : Graph[X]) -> Graph[X] {
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

///| reverse returns the reverse of the graph, i.e., the graph with all edges reversed.
pub fn[X] Graph::reverse(self : Graph[X]) -> Graph[X] {
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

///| subgraph returns the subgraph of the graph with the given nodes.
pub fn[X] Graph::subgraph(self : Graph[X], idxs : Array[Int]) -> Graph[X] {
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

///| union returns the union of the two graphs, i.e., the graph with all edges that are in either graph.
pub fn[X] Graph::union(self : Graph[X], other : Graph[X]) -> Graph[X] {
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

///| intersection returns the intersection of the two graphs, i.e., the graph with all edges that are in both graphs.
pub fn[X] Graph::intersection(self : Graph[X], other : Graph[X]) -> Graph[X] {
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

///| difference returns the difference of the two graphs, i.e., the graph with all edges that are in the first graph but not in the second.
pub fn[X] Graph::difference(self : Graph[X], other : Graph[X]) -> Graph[X] {
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

///| symmetric_difference returns the symmetric difference of the two graphs, i.e., the graph with all edges that are in either graph but not both.
pub fn[X] Graph::symmetric_difference(
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

///| complement returns the complement of the graph, i.e., the graph with all edges reversed.
pub fn[X] Graph::complement(self : Graph[X]) -> Graph[X] {
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

///| to_dot converts a graph to a dot format string.
pub fn[X] Graph::to_dot(self : Graph[X]) -> String {
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

///| single_source_dijkstra 返回从 source 到所有其他节点的最短路径，使用 Dijkstra 算法。
pub fn[X] Graph::single_source_dijkstra(
  self : Graph[X],
  source~ : Int
) -> (Array[Double], Array[Array[Int]]) {
  // 检查起点是否合法
  if source < 0 || source >= self.nodes.length() {
    return (
      Array::make(self.nodes.length(), @double.infinity),
      Array::make(self.nodes.length(), []),
    )
  }
  let n = self.nodes.length()
  // 初始化距离数组，所有节点距离为无穷大
  let dist = Array::make(n, @double.infinity)
  // 初始化路径数组
  let paths = Array::make(n, [])
  // 初始化已访问数组
  let visited = Array::make(n, false)
  // 初始化父节点数组
  let parent = Array::make(n, -1)
  dist[source] = 0.0
  for _ in 0..<n {
    // 找到未访问且距离最小的节点u
    let mut min_dist = @double.infinity
    let mut u = -1
    for j in 0..<n {
      if !visited[j] && dist[j] < min_dist {
        min_dist = dist[j]
        u = j
      }
    }
    // 如果没有可访问的节点，提前结束
    if u == -1 {
      break
    }
    visited[u] = true
    // 更新所有邻居节点的距离
    for v in 0..<n {
      if self.has_edge(u, v) && !visited[v] {
        let weight = self.edges[u][v]
        if dist[u] + weight < dist[v] {
          dist[v] = dist[u] + weight
          parent[v] = u
        }
      }
    }
  }

  // 构建每个节点的最短路径
  for i in 0..<n {
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

///|
test "single_source_dijkstra" {
  let graph : Graph[Int] = Graph::new()
  graph.add_nodes_from([0, 1, 2, 3])
  graph.add_edge(0, 1, weight=1.0)
  graph.add_edge(0, 2, weight=4.0)
  graph.add_edge(1, 2, weight=2.0)
  graph.add_edge(1, 3, weight=1.0)
  graph.add_edge(2, 3, weight=1.0)
  let (dist, paths) = graph.single_source_dijkstra(source=1)
  inspect(
    graph.to_string(),
    content="{nodes: [0, 1, 2, 3], edges: [[Infinity, 1, 4, Infinity], [1, Infinity, 2, 1], [4, 2, Infinity, 1], [Infinity, 1, 1, Infinity]]}",
  )
  inspect(dist, content="[1, 0, 2, 1]")
  inspect(paths, content="[[1, 0], [1], [1, 2], [1, 3]]")
}
