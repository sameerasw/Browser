//
//  Animation.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/11/25.
//

import SwiftUI

extension Animation {
    /// The default animation of the browser
    /// Depends of the `disable_animations` key saved in `UserDefaults`
    /// - Returns .bouncy of nil
    static var browserDefault: Animation? {
        UserDefaults.standard.bool(forKey: "disable_animations") ? nil : .bouncy
    }
}
