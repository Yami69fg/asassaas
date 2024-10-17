import UIKit

final class VibroManager {
    static let shared = VibroManager()
    private let feedbackGenerator = UIImpactFeedbackGenerator()
    
    func vibro() {
        if SettingsManager.vibrationsEnabled {
            feedbackGenerator.impactOccurred()
        }
    }
}
