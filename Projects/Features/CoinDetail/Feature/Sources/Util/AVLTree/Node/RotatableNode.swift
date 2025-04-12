//
//  RotatableNode.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/10/25.
//

public class RotatableNode<Value: Comparable>: Node<Value> {
    
    func rotateToParent() {
        guard let parent else { return }
        let isClockwise = parent.leftChild === self
        if isClockwise { clockwiseRotation(parent: parent) }
        else { reverseClockwiseRotation(parent: parent) }
    }
    
    private func clockwiseRotation(parent: Node<Value>) {
        // 조부모를 부모로 변경
        if let grandParent = parent.parent {
            parent.setParent(nil)
            self.setParent(grandParent)
            grandParent.setChild(self)
        }
        
        // 오른쪽 손자를 왼쪽 자식으로
        if let rightChild {
            self.setRightChild(nil)
            parent.setLeftChild(rightChild)
            rightChild.setParent(parent)
        }
        
        // 자식 부모관계 변경
        parent.removeChild(self)
        parent.setParent(self)
        setRightChild(parent)
    }
    
    private func reverseClockwiseRotation(parent: Node<Value>) {
        // 조부모를 부모로 변경
        if let grandParent = parent.parent {
            self.setParent(grandParent)
            grandParent.setChild(self)
        }
        
        // 왼쪽 손자를 오른쪽 자식으로
        if let leftChild {
            self.setLeftChild(nil)
            parent.setRightChild(leftChild)
            leftChild.setParent(parent)
        }
        
        // 자식 부모관계 변경
        parent.removeChild(self)
        parent.setParent(self)
        setLeftChild(parent)
    }
}
