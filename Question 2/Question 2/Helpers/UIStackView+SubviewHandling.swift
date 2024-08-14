//
//  UIStackView+SubviewHandling.swift
//  Question 2
//
//  Created by hlwan on 14/8/2024.
//

import Foundation
import UIKit

public protocol UIStackViewSubviewType {
    func accept(_ visitor: UIStackViewSubviewVisitor)
}

// As custom spacing
extension Int: UIStackViewSubviewType {
    public func accept(_ visitor: UIStackViewSubviewVisitor) {
        visitor.forInt(self)
    }
}

// As custom spacing
extension Double: UIStackViewSubviewType {
    public func accept(_ visitor: UIStackViewSubviewVisitor) {
        visitor.forDouble(self)
    }
}

// As custom spacing
extension CGFloat: UIStackViewSubviewType {
    public func accept(_ visitor: UIStackViewSubviewVisitor) {
        visitor.forCGFloat(self)
    }
}

extension UIView: UIStackViewSubviewType {
    public func accept(_ visitor: UIStackViewSubviewVisitor) {
        visitor.forUIView(self)
    }
}

extension Optional<UIView>: UIStackViewSubviewType {
    public func accept(_ visitor: UIStackViewSubviewVisitor) {
        visitor.forUIView(self)
    }
}

extension Array: UIStackViewSubviewType where Element: UIStackViewSubviewType {
    public func accept(_ visitor: UIStackViewSubviewVisitor) {
        visitor.forUIStackViewSubviewGroup(UIStackViewSubviewGroup(elements: self))
    }
}

struct UIStackViewSubviewGroup: UIStackViewSubviewType {
    let elements: [UIStackViewSubviewType]

    func accept(_ visitor: UIStackViewSubviewVisitor) {
        visitor.forUIStackViewSubviewGroup(self)
    }
}

public struct UIStackViewSubviewVisitor {
    let forUIView: (UIView?) -> Void
    let forUIStackViewSubviewGroup: (UIStackViewSubviewGroup) -> Void
    let forInt: (Int) -> Void
    let forDouble: (Double) -> Void
    let forCGFloat: (CGFloat) -> Void
}

@resultBuilder
public enum UIStackViewArrangedSubviewBuilder {
    public typealias Component = UIStackViewSubviewType

    public static func buildBlock(_ components: Component...) -> Component {
        return UIStackViewSubviewGroup(elements: components)
    }

    public static func buildEither(first: Component) -> Component {
        return first
    }

    public static func buildEither(second: Component) -> Component {
        return second
    }

    public static func buildArray(_ components: [Component]) -> Component {
        return UIStackViewSubviewGroup(elements: components)
    }
}

public extension UIStackView {
    private func createSubviewVisitor() -> UIStackViewSubviewVisitor {
        var previousView: UIView?
        return UIStackViewSubviewVisitor(
            forUIView: { view in
                if let view = view {
                    self.addArrangedSubview(view)
                    previousView = view
                }
            },
            forUIStackViewSubviewGroup: { group in
                let visitor = self.createSubviewVisitor()
                for element in group.elements {
                    element.accept(visitor)
                }
            },
            forInt: { spacing in
                if let view = previousView {
                    self.setCustomSpacing(CGFloat(spacing), after: view)
                }
            },
            forDouble: { spacing in
                if let view = previousView {
                    self.setCustomSpacing(spacing, after: view)
                }
            },
            forCGFloat: { spacing in
                if let view = previousView {
                    self.setCustomSpacing(spacing, after: view)
                }
            }
        )
    }

    /**
     Add arranged subviews with SwiftUI-like syntax. Also support `Int`, `Double`, `CGFloat` as custom spacings.

     For example:
     Given a vertical stack view, the following code
     ```
     stackView.addArrangedSubviews {
        label1
        12
        label2
        24
        view
     }
     ```
     will generate a layout like
     ```
     ┌──────────────────┐
     │      label1      │
     ├──────────────────┤
     │       (12)       │
     ├──────────────────┤
     │      label2      │
     ├──────────────────┤
     │                  │
     │       (24)       │
     │                  │
     ├──────────────────┤
     │       view       │
     └──────────────────┘
     ```
     */
    @discardableResult
    func addArrangedSubviews(@UIStackViewArrangedSubviewBuilder content: () -> UIStackViewSubviewType) -> Self {
        content().accept(createSubviewVisitor())
        return self
    }
}

public extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { v in
            removeArrangedSubview(v)
            v.removeFromSuperview()
        }
    }
}
