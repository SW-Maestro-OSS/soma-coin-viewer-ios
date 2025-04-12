//
//  OrderbookStore.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/12/25.
//

import CoreUtil

actor OrderbookStore {
    // State
    private let keyTree: AVLTree<CVNumber> = .init()
    private var orderQuantityTable: [CVNumber: CVNumber] = [:]
    
    func isRemovable(value: CVNumber) -> Bool { value.wrappedNumber <= 0 }
}


// MARK: Public interface
extension OrderbookStore {
    subscript (_ key: CVNumber) -> CVNumber? { get { orderQuantityTable[key] } }
    
    func clearStore() {
        keyTree.clear()
        orderQuantityTable.removeAll()
    }
    
    func update(key: CVNumber, value: CVNumber) {
        if let prev = orderQuantityTable[key] {
            // 키값이 이미 존재하는 경우, 업데이트
            let newValue = prev + value
            if isRemovable(value: newValue) {
                orderQuantityTable.removeValue(forKey: key)
                keyTree.remove(key)
            } else {
                orderQuantityTable[key] = newValue
            }
        } else {
            // 새로운 키값 등록
            orderQuantityTable[key] = value
            keyTree.insert(key)
        }
    }
    
    func getAscendingList(count: Int) -> [(CVNumber, CVNumber)] {
        keyTree
            .getAscendingList(maxCount: count)
            .map { key in (key, orderQuantityTable[key]!) }
    }
    
    func getDescendingList(count: Int) -> [(CVNumber, CVNumber)] {
        keyTree
            .getDiscendingList(maxCount: count)
            .map { key in (key, orderQuantityTable[key]!) }
    }
}
