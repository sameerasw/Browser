//
//  Error.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/4/25.
//

import Foundation

// Simple String Error
extension String: @retroactive Error {}
extension String: @retroactive LocalizedError {
    public var errorDescription: String? { self }
}
