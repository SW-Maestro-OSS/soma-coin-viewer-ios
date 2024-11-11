//
//  SortOperator.swift
//  Domain
//
//  Created by choijunios on 11/11/24.
//

public enum OrderType {
    case ASC, DESC
}

open class SortOperator<T> {
    func orderType() -> OrderType { .ASC }
    func sortingMethod(lhs: T, rhs: T) -> Bool { true }
}
