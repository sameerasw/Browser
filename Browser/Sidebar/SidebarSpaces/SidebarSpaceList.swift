//
//  SidebarSpaceList.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/31/25.
//

import SwiftUI
import SwiftData

struct SidebarSpaceList: View {
    @Query var browserSpaces: [BrowserSpace]
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(browserSpaces) { browserSpace in
                    Text(browserSpace.name)
                }
            }
        }
    }
}

#Preview {
    SidebarSpaceList()
}
