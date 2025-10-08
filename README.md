# Zero - A minimal fancy browser

![CleanShot 2025-10-08 at 3  44 10@2x Large](https://github.com/user-attachments/assets/0053365a-76c3-478b-aea5-ec8754e95c22)

## Motivation

This browser **—still without a name or icon—** is just a fun side project to sharpen my Swift and SwiftUI skills. It’s highly experimental and unstable, so it’s not meant for real use.
## Technologies

- _SwiftUI_: Powers the app's entire user interface.
- _SwiftData_: Persists data such as Spaces and Tabs.
- _WebKit_: The Browser's Engine.

<img width="1512" alt="Browser with No-Trace Window" src="https://github.com/user-attachments/assets/a761c164-ece6-4f6d-bba6-e012d307a670" />

## Features

- [x] Multiples Spaces
- [x] No-Trace Window
- [x] Temporary Window
- [x] Translate websites
- [x] Web Inspector
- [x] History
- [x] Keyboard Shortcuts
- [x] Ad Blocker
- [x] **Website search with autosuggestions _on some websistes_**

https://github.com/user-attachments/assets/90738982-651a-4991-8580-866325d1d128

- [x] Picture-in-Picutre
- [x] Search in Page
- [x] Reorder Tabs By Dragging
- [x] Export Page as PDF, Image, etc...       
- [ ] Multiple Windows
- [ ] Grid Layout
- [x] Pinned Tabs
- [ ] Undo and Redo Closed Tabs
- [ ] Page Suspension

## Building

The project now links against the system-provided WebKit, so a custom WebKit.framework checkout is no longer required. Open `Browser.xcodeproj` and build the `Browser` scheme with the latest Xcode on macOS.

Credits to [LeonardoLarranaga/Browser](https://github.com/LeonardoLarranaga/Browser)
