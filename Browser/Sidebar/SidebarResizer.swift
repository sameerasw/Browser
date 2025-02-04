//
//  SidebarResizer.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 1/28/25.
//

import SwiftUI

struct SidebarResizer: View {
    
    @EnvironmentObject var sidebarModel: SidebarModel
    
    @State var isDragging = false
    
    var body: some View {
        // View base
        Color.clear
            .frame(width: 0.1)
            .overlay(alignment: .top) {
                // Visual dragger
                Color.secondary.opacity(isDragging && sidebarModel.currentSidebarWidth != 0 ? 0.2 : 0)
                    .animation(.bouncy, value: isDragging)
                    .clipShape(.rect(cornerRadius: 12))
                    .frame(width: 5)
                    .padding(.vertical)
            }
            .overlay(alignment: .top) {
                // Actual dragger
                Color.clear
                    .frame(width: 15)
                    .onHover { hover in
                        if hover {
                            NSCursor.resizeLeftRight.push()
                        } else {
                            if !isDragging {
                                setArrowNSCursor()
                            }
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged(resizeSidebar)
                            .onEnded(endDragging)
                    )
            }
    }
    
    private func resizeSidebar(with value: DragGesture.Value) {
        if isDragging == false {
            sidebarModel.lastSidebarWidth = sidebarModel.currentSidebarWidth
        }
        
        isDragging = true
        let newWidth = sidebarModel.currentSidebarWidth + value.translation.width
        if newWidth >= .minimumSidebarWidth && newWidth <= .maximumSidebarWidth {
            let fixedWidth = newWidth / .preferredSidebarWidth
            if fixedWidth > 0.95 && fixedWidth < 1.06 {
                sidebarModel.currentSidebarWidth = .preferredSidebarWidth
            } else {
                sidebarModel.currentSidebarWidth = newWidth
            }
        } else {
            if newWidth < .minimumSidebarWidth * 0.5 {
                sidebarModel.currentSidebarWidth = 0
            }
        }
    }
    
    private func endDragging(with value: DragGesture.Value) {
        isDragging = false
        setArrowNSCursor()
        
        if sidebarModel.currentSidebarWidth == 0 {
            sidebarModel.sidebarCollapsed = true
        }
    }
    
    private func setArrowNSCursor() {
        while NSCursor.current != .arrow {
            NSCursor.pop()
        }
    }
}
