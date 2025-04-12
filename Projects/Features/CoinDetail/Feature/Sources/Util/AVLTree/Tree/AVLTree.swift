//
//  AVLTree.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/10/25.
//

final public class AVLTree<Value: Comparable>: BinarySearchTree<Value, AVLNode<Value>> {

    override func createNode(value: Value, parent: Node<Value>) -> AVLNode<Value> {
        AVLNode(value: value, parent: parent)
    }
    
    override func onInsertion(insertedNode node: AVLNode<Value>) {
        if let parent = node.parent as? AVLNode {
            do {
                try parent.startBalancing()
            } catch {
                print("[\(Self.self)] \(error)")
            }
        }
    }
    
    override func onRemoval(removalInfo: BinarySearchTree<Value, AVLNode<Value>>.BSTNodeRemoval) {
        do {
            switch removalInfo {
            case .noSub(let targetParent):
                try targetParent?.startBalancing()
            case .subExists(let subNode, let prevSubNodeParent):
                if let prevSubNodeParent {
                    subNode.updateFactors()
                    try prevSubNodeParent.startBalancing()
                } else {
                    try subNode.startBalancing()
                }   
            }
        } catch {
            print("[\(Self.self)] \(error)")
        }
    }
}


// MARK: Tree height
public extension AVLTree {
    var treeHeight: Int {
        guard let rootNode else { return 0 }
        return rootNode.height+1
    }
}
