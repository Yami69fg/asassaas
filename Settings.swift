import UIKit

extension UIButton {
    func setImageForAllStates(_ image: UIImage) {
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
        contentMode = .scaleAspectFit
    }
}

extension UIViewController {
    func scaleAnimationsAndFeedbackTo(_ button: UIButton) {
        button.addTarget(self, action: #selector(downscale(sender: )), for: .touchDown)
        button.addTarget(self, action: #selector(upscale(sender: )), for: .touchUpInside)
        button.addTarget(self, action: #selector(upscale(sender: )), for: .touchDragOutside)
    }
    
    @objc private func upscale(sender: UIButton) {
        sender.transform = CGAffineTransformMakeScale(1, 1)
    }
    
    @objc private func downscale(sender: UIButton) {
        SoundManager.shared.playFeedbackSound()
        VibroManager.shared.vibro()
        sender.transform = CGAffineTransformMakeScale(0.98, 0.98)
    }
}
