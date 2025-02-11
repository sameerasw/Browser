//
//  Animation.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/11/25.
//

import SwiftUI

extension Animation {
    static var browserDefault: Animation? {
        UserDefaults.standard.bool(forKey: "disable_animations") ? nil : .bouncy
    }
}
