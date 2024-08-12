import Foundation

public let graph: [String: [String]] = [
    "A": ["B", "D", "H"],
    "B": ["A", "C", "D"],
    "C": ["B", "D", "F"],
    "D": ["A", "B", "C", "E"],
    "E": ["D", "F", "H"],
    "F": ["C", "E", "G"],
    "G": ["F", "H"],
    "H": ["A", "E", "G"],

]
