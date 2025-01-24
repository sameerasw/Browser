//
//  MainFrame.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/23/25.
//

import SwiftUI

struct MainFrame: View {
    
    @StateObject var sidebarModel = SidebarModel()
    
    var body: some View {
        HStack(spacing: 0) {
            if !sidebarModel.sidebarCollapsed {
                Sidebar()
                    .frame(width: sidebarModel.currentSidebarWidth)
                    .readingWidth(width: $sidebarModel.currentSidebarWidth)
                Dragger()
            }
            WebView()
        }
        .toolbar { Text("") }
        .environmentObject(sidebarModel)
    }
}

struct Dragger: View {
    
    @EnvironmentObject var sidebarModel: SidebarModel
    
    let minimumSidebarWidth = CGFloat(150)
    let maximumSidebarWidth = CGFloat(500)
    
    @State var isDragging = false
    
    var body: some View {
        Color.blue
            .frame(width: 0.1)
            .overlay(alignment: .top) {
                Color.clear
                    .frame(width: 15)
                    .onHover { hover in
                        if hover {
                            NSCursor.resizeLeftRight.push()
                        } else {
                            if !isDragging {
                                NSCursor.pop()
                            }
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if isDragging == false {
                                    sidebarModel.lastSidebarWidth = sidebarModel.currentSidebarWidth
                                }
                                
                                isDragging = true
                                let newWidth = sidebarModel.currentSidebarWidth + value.translation.width
                                if newWidth >= minimumSidebarWidth && newWidth <= maximumSidebarWidth {
                                    sidebarModel.currentSidebarWidth = newWidth
                                } else {
                                    if newWidth < minimumSidebarWidth * 0.5 {
                                        sidebarModel.currentSidebarWidth = 0
                                    }
                                }
                            }
                            .onEnded { value in
                                isDragging = false
                                while NSCursor.current == .resizeLeftRight {
                                    NSCursor.pop()
                                }
                                
                                if sidebarModel.currentSidebarWidth == 0 {
                                    sidebarModel.sidebarCollapsed = true
                                }
                            }
                    )
            }
        
    }
}
