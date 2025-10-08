
import SwiftUI
import AppKit

// MARK: - NSView that monitors middle (other) mouse clicks inside its bounds
final class MiddleClickDetectorView: NSView {
    var onMiddleClick: (() -> Void)?

    // Keep a reference to the local monitor so we can remove it later
    private var localMonitor: Any?

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        installMonitor()
    }

    deinit {
        removeMonitor()
    }

    private func installMonitor() {
        removeMonitor()

        // local monitor sees events before the normal event dispatch
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .otherMouseDown) { [weak self] event in
            guard let self = self, let window = self.window else { return event }

            // Convert the event's window coords into this view's local coords
            let pointInWindow = event.locationInWindow
            let pointInView = self.convert(pointInWindow, from: nil)

            if self.bounds.contains(pointInView) {
                // Call the action on main thread (safe for SwiftUI)
                DispatchQueue.main.async {
                    self.onMiddleClick?()
                }
            }

            // Return the event so normal processing still happens
            return event
        }
    }

    private func removeMonitor() {
        if let m = localMonitor {
            NSEvent.removeMonitor(m)
            localMonitor = nil
        }
    }
}

// MARK: - SwiftUI wrapper
struct MiddleClickDetector: NSViewRepresentable {
    let onMiddleClick: () -> Void

    func makeNSView(context: Context) -> MiddleClickDetectorView {
        let v = MiddleClickDetectorView()
        v.onMiddleClick = onMiddleClick
        // Keep it invisible but present in hierarchy
        v.wantsLayer = true
        v.layer?.backgroundColor = NSColor.clear.cgColor
        return v
    }

    func updateNSView(_ nsView: MiddleClickDetectorView, context: Context) {
        nsView.onMiddleClick = onMiddleClick
    }
}

// MARK: - Convenient View modifier
extension View {
    /// Adds a middle-click handler that triggers when the user middle-clicks inside this view.
    /// The detector uses an event monitor (doesn't block/steal left-clicks).
    func onMiddleClick(perform action: @escaping () -> Void) -> some View {
        // place the detector on top (overlay) so its frame matches the SwiftUI view's frame.
        overlay(
            GeometryReader { proxy in
                MiddleClickDetector(onMiddleClick: action)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                // important: detector only observes events, don't let it block hit-testing
                    .allowsHitTesting(false)
            }
        )
    }
}
