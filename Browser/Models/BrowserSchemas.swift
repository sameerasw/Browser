//
//  BrowserSchemas.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import Foundation
import SwiftData

enum BrowserSchemaV001: VersionedSchema {
    static var versionIdentifier: Schema.Version = Schema.Version(0, 0, 1)
    static var models: [any PersistentModel.Type] {
        [BrowserSpace.self, BrowserTab.self]
    }
}

enum BrowserSchemaV002: VersionedSchema {
    static var versionIdentifier: Schema.Version = Schema.Version(0, 0, 2)
    static var models: [any PersistentModel.Type] {
        [BrowserSpace.self, BrowserTab.self]
    }
}   
