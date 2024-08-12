import UIKit
/**
 Answers to question 1
 https://github.com/moovup/programming-test/blob/master/mobile.md
 */

/**
 
 */
func getAllPossiblePaths(graph: [String: [String]], from: String, to: String) -> [[String]] {
//    var queue: [Node] = [node]
//    var map: [Node: [Node]] = [:]
//    while !queue.isEmpty {
//        let currentNode = queue.removeFirst()
//        if map[currentNode] != nil {
//            continue
//        }
//        
//        map[currentNode] = currentNode.neighbours
//        queue.append(contentsOf: currentNode.neighbours)
//    }
//    return map
}

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
