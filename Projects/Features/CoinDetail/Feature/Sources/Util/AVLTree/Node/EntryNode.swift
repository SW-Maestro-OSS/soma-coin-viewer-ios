//
//  EntryNode.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/10/25.
//

final class EntryNode<Value: Comparable>: Node<Value> {
    private(set) var child: Node<Value>?
    override var rightChild: Node<Value>? { self.child }
    override var leftChild: Node<Value>? { self.child }
    
    override func setChild(_ node: Node<Value>) { child = node }
    override func setRightChild(_ node: Node<Value>?) { child = node }
    override func setLeftChild(_ node: Node<Value>?) { child = node }
    override func removeChild(_ node: Node<Value>) {
        if child === node { child = nil }
    }
    override func setParent(_ parentNode: Node<Value>?) { }
}
