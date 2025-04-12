//
//  BinarySearchTree.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/10/25.
//

public struct MemoryLeakChecker {
    private weak var object: AnyObject?
    init(object: AnyObject) {
        self.object = object
    }
    public func isReleased() -> Bool { object == nil }
}

open class BinarySearchTree<Value: Comparable, TreeNode: Node<Value>> {
    // State
    private let entryNode: EntryNode<Value> = .init(value: nil)
    
    var rootNode: TreeNode? { entryNode.child as? TreeNode }
    
    public init() { }
    
    func createNode(value: Value, parent: Node<Value>) -> TreeNode {
        TreeNode(value: value, parent: parent)
    }
    func onInsertion(insertedNode: TreeNode) { }
    enum BSTNodeRemoval {
        case noSub(targetParent: TreeNode?)
        case subExists(subNode: TreeNode, prevSubNodeParent: TreeNode?)
    }
    func onRemoval(removalInfo: BSTNodeRemoval) { }
}


// MARK: Public interface: insert & remove
public extension BinarySearchTree {
    /// 값을 트리에 추가합니다.
    final func insert(_ value: Value) {
        // 루트노드가 비어 있는 경우
        if rootNode == nil {
            let newRootNode = createNode(value: value, parent: entryNode)
            self.entryNode.setChild(newRootNode)
            self.onInsertion(insertedNode: newRootNode)
            return
        }
        
        // 위치 찾기
        var compareNode: Node<Value> = rootNode!
        while true {
            if compareNode.value < value {
                // 삽입 값이 더 큰 경우, 오른쪽 노드 접근
                guard let rightChild = compareNode.rightChild else { break }
                compareNode = rightChild
            } else if compareNode.value > value {
                // 삽입 값이 더 작은 경우, 왼쪽 노드 접근
                guard let leftChild = compareNode.leftChild else { break }
                compareNode = leftChild
            } else {
                // 중복 요소 배제
                return
            }
        }
        
        // 새로운 노드 생성 및 삽입
        let newNode = createNode(value: value, parent: compareNode)
        compareNode.setChild(newNode)
        self.onInsertion(insertedNode: newNode)
    }
    
    /// 값이 트리에 존재할 경우 값을 삭제합니다.
    @discardableResult
    final func remove(_ value: Value) -> MemoryLeakChecker? {
        guard let rootNode else { return nil }
        var targetNode: Node<Value> = rootNode
        while true {
            if targetNode.value < value {
                guard let rightChild = targetNode.rightChild else { return nil }
                targetNode = rightChild
            } else if targetNode.value > value {
                guard let leftChild = targetNode.leftChild else { return nil }
                targetNode = leftChild
            } else {
                // 동일한 값을 가지는 노드를 발견한 경우
                break
            }
        }
        
        // 대체자 찾기
        var subNode: Node<Value>?
        if let minNodeInRight = targetNode.getMinNodeInRightLayer() {
            subNode = minNodeInRight
        } else if let maxNodeInLeft = targetNode.getMaxNodeInLeftLayer() {
            subNode = maxNodeInLeft
        }
        
        var prevSubNodeParent: TreeNode?
        if let subNode {
            // 대체노드가 있는 경우
            prevSubNodeParent = subNode.parent as? TreeNode
            subNode.parent?.removeChild(subNode)
            subNode.setParent(nil)
            
            if let parentNode = targetNode.parent {
                // 타겟의 부모를 대체 노드로 이전
                subNode.setParent(parentNode)
                parentNode.setChild(subNode)
            }
            if let rightNode = targetNode.rightChild, rightNode !== subNode {
                // 타겟의 오른쪽 자식을 이전
                subNode.setRightChild(rightNode)
                rightNode.setParent(subNode)
                targetNode.setRightChild(nil)
            }
            if let leftNode = targetNode.leftChild, leftNode !== subNode {
                // 타겟의 왼쪽 자식을 이전
                subNode.setLeftChild(leftNode)
                leftNode.setParent(subNode)
                targetNode.setLeftChild(nil)
            }
        }
        
        // 타겟 노드 삭제
        let targetNodeParent = targetNode.parent
        targetNode.parent?.removeChild(targetNode)
        targetNode.setParent(nil)
        
        if let subNode {
            onRemoval(removalInfo: .subExists(
                subNode: subNode as! TreeNode,
                prevSubNodeParent: prevSubNodeParent === targetNode ? nil : prevSubNodeParent
            ))
        } else {
            onRemoval(removalInfo: .noSub(
                targetParent: targetNodeParent as? TreeNode
            ))
        }
        
        return MemoryLeakChecker(object: targetNode)
    }
    
    final func clear() {
        guard let rootNode else { return }
        postOrderTraversal(node: rootNode, action: { node in
            node.setLeftChild(nil)
            node.setRightChild(nil)
            node.setParent(nil)
        })
        entryNode.removeChild(rootNode)
    }
}


// MARK: Public interface: sorted list
public extension BinarySearchTree {
    final func getAscendingList(maxCount: Int) -> [Value] {
        guard let rootNode else { return [] }
        var list: [Value] = []
        inOrderLeftTraversal(node: rootNode, list: &list, maxCount: maxCount)
        return list
    }
    
    final func getDiscendingList(maxCount: Int) -> [Value] {
        guard let rootNode else { return [] }
        var list: [Value] = []
        inOrderRightTraversal(node: rootNode, list: &list, maxCount: maxCount)
        return list
    }
}


// MARK: 순회 함수
private extension BinarySearchTree {
    func inOrderLeftTraversal(node: Node<Value>, list: inout [Value], maxCount: Int) {
        if let leftChild = node.leftChild {
            inOrderLeftTraversal(node: leftChild, list: &list, maxCount: maxCount)
        }
        
        if list.count >= maxCount { return }
        list.append(node.value)
        
        if let rightChild = node.rightChild {
            inOrderLeftTraversal(node: rightChild, list: &list, maxCount: maxCount)
        }
    }
    
    func inOrderRightTraversal(node: Node<Value>, list: inout [Value], maxCount: Int) {
        if let rightChild = node.rightChild {
            inOrderRightTraversal(node: rightChild, list: &list, maxCount: maxCount)
        }
        
        if list.count >= maxCount { return }
        list.append(node.value)
        
        if let leftChild = node.leftChild {
            inOrderRightTraversal(node: leftChild, list: &list, maxCount: maxCount)
        }
    }
    
    func postOrderTraversal(node: Node<Value>, action: (Node<Value>) -> ()) {
        if let leftChild = node.leftChild {
            postOrderTraversal(node: leftChild, action: action)
        }
        if let rightChild = node.rightChild {
            postOrderTraversal(node: rightChild, action: action)
        }
        action(node)
    }
}


// MARK: For test
extension BinarySearchTree {
    func clearWithCheckers() -> [MemoryLeakChecker] {
        guard let rootNode else { return [] }
        var checkers: [MemoryLeakChecker] = []
        postOrderTraversal(node: rootNode, action: { node in
            checkers.append(.init(object: node))
        })
        self.clear()
        return checkers
    }
}
