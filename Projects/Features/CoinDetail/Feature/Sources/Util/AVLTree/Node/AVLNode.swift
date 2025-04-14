//
//  AVLNode.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/10/25.
//

enum AVLNodeError: Error {
    case nodeNotFound
    case tryToGetNodeWhenNeutralStateOnFirst
}

final public class AVLNode<Value: Comparable>: RotatableNode<Value> {
    // State
    private(set) var balanceFactor: Int = 0
    private(set) var height: Int = 0
    
    private var left: AVLNode? { leftChild as? AVLNode }
    private var right: AVLNode? { rightChild as? AVLNode }
    
    func startBalancing() throws {
        var currentNode: Node? = self
        while let node = currentNode as? AVLNode {
            node.updateFactors()
            if abs(node.balanceFactor) > 1 {
                let (firstDirec, d1Child) = try node.findDirectionAndChild()
                let (secondDirec, d2Child) = try d1Child.findDirectionAndChild(firstDirec)
                let directionPair = DirectionPair.getPair(
                    first: firstDirec,
                    second: secondDirec
                )
                var rotatingNode: AVLNode!
                switch directionPair {
                case .LL, .RR:
                    rotatingNode = d1Child
                    rotatingNode.rotateToParent()
                    
                case .LR, .RL:
                    rotatingNode = d2Child
                    rotatingNode.rotateToParent()
                    rotatingNode.rotateToParent()
                }
                rotatingNode.left?.updateFactors()
                rotatingNode.right?.updateFactors()
                rotatingNode.updateFactors()
                currentNode = rotatingNode.parent
            }
            else { currentNode = node.parent }
        }
    }
    
    func updateFactors() {
        let leftHeight = left?.height ?? -1
        let rightHeight = right?.height ?? -1
        
        // Height
        self.height = max(leftHeight, rightHeight)+1
        
        // Balance factor
        self.balanceFactor = leftHeight - rightHeight
    }
}


// MARK: Balancing utils
private extension AVLNode {
    enum DirectionPair {
        case LL, RR, LR, RL
        static func getPair(first: BalanceDirection, second: BalanceDirection) -> Self {
            switch (first, second) {
            case (.Left, .Right):
                return .LR
            case (.Right, .Right):
                return .RR
            case (.Left, .Left):
                return .LL
            case (.Right, .Left):
                return .RL
            }
        }
    }
    
    enum BalanceDirection {
        case Left, Right
    }
    
    func getChild(_ prevDirection: BalanceDirection) throws -> AVLNode {
        switch prevDirection {
        case .Left:
            guard let leftNode = left else { throw AVLNodeError.nodeNotFound }
            return leftNode
        case .Right:
            guard let rightNode = right else { throw AVLNodeError.nodeNotFound }
            return rightNode
        }
    }
    
    func findDirectionAndChild(_ prevDirection: BalanceDirection? = nil) throws -> (BalanceDirection, AVLNode) {
        if balanceFactor < 0 {
            // 우측으로 쏠려있는 경우
            return (.Right, try getChild(.Right))
        } else if balanceFactor > 0 {
            // 좌측으로 쏠려있는 경우
            return (.Left, try getChild(.Left))
        } else {
            // 균형 상태인 경우
            guard let prevDirection else { throw AVLNodeError.tryToGetNodeWhenNeutralStateOnFirst }
            switch prevDirection {
            case .Left:
                return (prevDirection, try getChild(.Left))
            case .Right:
                return (prevDirection, try getChild(.Right))
            }
        }
    }
}
