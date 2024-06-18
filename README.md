# oboard/moonetx

> MoonBit Network Analysis Library

## 📖Table of Contents

- [Introduction](#-introduction)
- [Getting Started](#-getting-started)
- [Contributing](#-contributing)
- [License](#-license)

## ✨Introduction

**MoonetX** is an open-source MoonBit library that provides support for network analytic tools.


## 🚀Getting Started

```sh
moon install oboard/moonetx
```

> Graph

```rust
fn find_neighbors() -> Array[Int] {
  let graph = @nx.Graph::new()
  graph.add_nodes_from([0, 1, 2, 3, 4, 5])
  graph.add_edges_from([(1, 2), (2, 5)])
  graph.neighbors(2)
}
```

> DiGraph

```rust
fn get_in_degree() -> Int {
  let graph = @nx.DiGraph::new()
  graph.add_nodes_from([0, 1, 2, 3, 4, 5])
  graph.add_edges_from([(1, 2), (2, 5)])
  graph.in_degree(2)
}

Output: 1
```

## 🤝Contributing

Contributions, issues and feature requests are welcome!<

Feel free to check [issues page](https://github.com/oboard/moonetx/issues). 

## 📝License

This project is [MIT](LICENSE.md) licensed.