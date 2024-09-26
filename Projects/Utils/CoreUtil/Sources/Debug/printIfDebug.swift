//
//  printIfDebug.swift
//  CoreUtil
//
//  Created by choijunios on 9/26/24.
//

import Foundation

public func printIfDebug(_ items: Any...) {
    #if DEBUG
    print(items)
    #endif
}
