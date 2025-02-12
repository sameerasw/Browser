//
//  URLQRCodeView.swift
//  Browser
//
//  Created by Leonardo Larrañaga on 2/8/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct URLQRCodeView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let browserTab: BrowserTab?
    
    @State var nsImage = NSImage()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(nsImage: nsImage)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
            }
            .navigationTitle(browserTab?.title ?? "")
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Button("Copy", action: copyToClipboard)
                    Button("Save", action: saveImage)
                }
                
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Done", action: dismiss.callAsFunction)
                }
            }
        }
        .task {
            if browserTab == nil {
                dismiss()
            } else {
                generateQRImage()
            }
        }
    }
    
    private func generateQRImage() {
        guard let url = browserTab?.url,
              let data = url.absoluteString.data(using: .utf8)
        else { return dismiss() }
        
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = data
        
        if let outputImage = filter.outputImage {
            let scaledImage = outputImage.transformed(by: .init(scaleX: 20, y: 20))
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                nsImage = NSImage(cgImage: cgImage, size: scaledImage.extent.size)
            }
        }
    }
    
    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([nsImage])
    }
    
    private func saveImage() {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.nameFieldStringValue = browserTab?.title ?? "QR Code"
        savePanel.canCreateDirectories = true
        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                if let tiffData = nsImage.tiffRepresentation,
                   let imageRep = NSBitmapImageRep(data: tiffData),
                   let pngData = imageRep.representation(using: .png, properties: [:]) {
                    try? pngData.write(to: url)
                }
            }
        }
    }
}
