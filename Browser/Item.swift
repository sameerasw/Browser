//
//  Item.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/18/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
