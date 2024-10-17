import Foundation

final class SettingsManager {
    private static let defaults = UserDefaults.standard
    
    static var vibrationsEnabled: Bool {
        get { defaults.value(forKey: #function) as? Bool ?? true }
        set { defaults.set(newValue, forKey: #function) }
    }
    
    static var soundsEnabled: Bool {
        get { defaults.value(forKey: #function) as? Bool ?? true }
        set { defaults.set(newValue, forKey: #function) }
    }
    
    static var bestScore: Int {
        get { defaults.value(forKey: #function) as? Int ?? 0 }
        set { defaults.set(newValue, forKey: #function) }
    }
}
