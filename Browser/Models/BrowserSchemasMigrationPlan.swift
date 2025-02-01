//
//  BrowserSchemasMigrationPlan.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import SwiftData

enum BrowserSchemasMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [BrowserSchemaV001.self, BrowserSchemaV002.self]
    }
    
    static var stages: [MigrationStage] {
        [migrateV001ToV002]
    }
    
    static let migrateV001ToV002 = MigrationStage.lightweight(fromVersion: BrowserSchemaV001.self, toVersion: BrowserSchemaV002.self)
}
