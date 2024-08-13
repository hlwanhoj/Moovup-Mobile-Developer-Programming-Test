import UIKit
/**
 Answers to question 1
 https://github.com/moovup/programming-test/blob/master/mobile.md
 */

/**
 Answer 1a
 */
struct TempPath {
    var nodes: [String]
    var set: Set<String>
}
func getAllPossiblePaths(graph: [String: [String]], from start: String, to end: String) -> [[String]] {
    var paths: [TempPath] = [TempPath(nodes: [start], set: [start])]
    var output: [[String]] = []
    while !paths.isEmpty {
        var newPaths: [TempPath] = []
        for path in paths {
            guard let lastNode = path.nodes.last else {
                continue
            }
            
            if lastNode == end {
                // We found a path if we reach the end node
                output.append(path.nodes)
            } else {
                // Visit all unvisited current node's neighbours
                for neighbour in graph[lastNode] ?? [] {
                    if !path.set.contains(neighbour) {
                        newPaths.append(
                            TempPath(
                                nodes: path.nodes + [neighbour],
                                set: path.set.union([neighbour])
                            )
                        )
                    }
                }
            }
        }
        paths = newPaths
    }
    
    return output
}
let allPossiblePaths = getAllPossiblePaths(graph: graph, from: "A", to: "H")


// MARK: -

/**
 Answer 1b
 */
func getLeastNumberOfHops(graph: [String: [String]], node: String) -> [String: Int] {
    var distances: [String: Int] = [:]
    for key in graph.keys {
        distances[key] = Int.max
    }
    distances[node] = 0
    
    // Use Dijkstra's algorithm to find shortest path
    var queue: [(String, Int)] = [(node, 0)]
    while !queue.isEmpty {
        // No need to sort as distance between nodes is 1
        let (node, distance) = queue.removeFirst()
        if distances[node]! < distance {
            continue
        }
        
        if let neighbours = graph[node] {
            for neighbour in neighbours {
                // If current distance is lower, Update distance cache and explore the neighbour node
                let neighbourDist = distance + 1
                if neighbourDist < distances[neighbour]! {
                    distances[neighbour] = neighbourDist
                    queue.append((neighbour, neighbourDist))
                }
            }
        }
    }
    return distances
}

let distanceToA = getLeastNumberOfHops(graph: graph, node: "A")
// Distance to itself is 0
assert(distanceToA["A"] == 0)
// Shortest path between A and G is A-H-G
assert(distanceToA["G"] == 2)
// A and H is directly connected
assert(distanceToA["H"] == 1)
