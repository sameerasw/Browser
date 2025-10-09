//
//  HapticFeedback.swift
//  Browser
//
//  Created by GitHub Copilot on 10/9/25.
//

import AppKit

/// Utility class for haptic feedback throughout the app
class HapticFeedback {
    
    static let shared = HapticFeedback()
    
    private let feedbackPerformer = NSHapticFeedbackManager.defaultPerformer
    
    private init() {}
    
    /// Performs a generic haptic feedback
    func perform() {
        feedbackPerformer.perform(.generic, performanceTime: .default)
    }
    
    /// Performs a level change haptic feedback (good for navigation changes)
    func performLevelChange() {
        feedbackPerformer.perform(.levelChange, performanceTime: .default)
    }
    
    /// Performs an alignment haptic feedback (good for snapping/alignment)
    func performAlignment() {
        feedbackPerformer.perform(.alignment, performanceTime: .default)
    }
    
    /// Performs a generic haptic feedback with custom performance time
    func perform(_ pattern: NSHapticFeedbackManager.FeedbackPattern, performanceTime: NSHapticFeedbackManager.PerformanceTime = .default) {
        feedbackPerformer.perform(pattern, performanceTime: performanceTime)
    }
}