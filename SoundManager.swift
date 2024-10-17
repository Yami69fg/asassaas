import AVFoundation

final class SoundManager {
    static let shared = SoundManager()
    private var feedbackPlayer = AVAudioPlayer()
    
    func initPlayer() {
        soundPlaySettings()
    }
    
    func playFeedbackSound() {
        if SettingsManager.soundsEnabled {
            feedbackPlayer.stop()
            feedbackPlayer.currentTime = 0
            feedbackPlayer.play()
        }
    }
    
    private func soundPlaySettings() {
        if let soundStringPath = Bundle.main.path(forResource: "buttonTouchSound.mp3", ofType: nil) {
            let urlOfSound = URL(fileURLWithPath: soundStringPath)
            do {
                feedbackPlayer = try AVAudioPlayer(contentsOf: urlOfSound)
            } catch {
                print("Coordinator error")
            }
            feedbackPlayer.prepareToPlay()
        }
    }
}
