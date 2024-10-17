import UIKit
import SpriteKit

final class PauseController: UIViewController {
    private var shadow = UIImageView(image: .shadow)
    private var settingsBG = UIImageView(image: .settingsBG)
    private var settingsLabelImage = UIImageView(image: .settingsLabel)
    private var label = UIImageView(image: .sound)
    
    private var topArea = UIView()
    private var bottomArea = UIView()
    
    var closeButton = UIButton()
    var vibroButton = UIButton()
    var soundButton = UIButton()
    
    var exitGameClosure: (() -> ())?
    var closeSettingsControllerClosure: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controllerConfiguration()
        addElements()
    }
    
    @objc func dismissWithTap() {
        closeSettingsControllerClosure?()
        dismiss(animated: false)
    }
    
    private func controllerConfiguration() {
        targetCloseButton()
    }
    
    private func targetCloseButton() {
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        scaleAnimationsAndFeedbackTo(closeButton)
    }
    
    @objc private func close() {
        dismiss(animated: false)
        exitGameClosure?()
    }
    
    private func addElements() {
        view.addSubview(shadow)
        view.addSubview(settingsBG)
        view.addSubview(settingsLabelImage)
        view.addSubview(label)
        view.addSubview(closeButton)
        view.addSubview(topArea)
        view.addSubview(bottomArea)
        view.addSubview(vibroButton)
        view.addSubview(soundButton)
        
        shadow.alpha = 0.4
        shadow.contentMode = .scaleAspectFill
        settingsBG.contentMode = .scaleAspectFit
        settingsLabelImage.contentMode = .scaleAspectFit
        label.contentMode = .scaleAspectFit
        closeButton.setImageForAllStates(.closeButton)
        setImageFor(button: &soundButton, type: .sound)
        setImageFor(button: &vibroButton, type: .vibro)
        
        shadow.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        settingsBG.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(180)
        }
        
        settingsLabelImage.snp.makeConstraints { make in
            make.centerY.equalTo(settingsBG.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(85)
        }
        
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(settingsBG.snp.bottom).offset(-8)
        }
        
        topArea.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(settingsBG.snp.top)
        }
        
        bottomArea.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(closeButton.snp.bottom)
        }
        
        label.snp.makeConstraints { make in
            make.width.equalTo(210)
            make.height.equalTo(23)
            make.centerX.equalToSuperview()
            make.top.equalTo(settingsLabelImage.snp.bottom).offset(15)
        }
        
        vibroButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.centerX.equalToSuperview().offset(-50)
            make.top.equalTo(label.snp.bottom).offset(15)
        }
        
        soundButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.centerX.equalToSuperview().offset(50)
            make.centerY.equalTo(vibroButton)
        }
        
        soundButton.addTarget(self, action: #selector(soundTappde), for: .touchUpInside)
        vibroButton.addTarget(self, action: #selector(vibroTappde), for: .touchUpInside)
        
        let upTap = UITapGestureRecognizer(target: self, action: #selector(dismissWithTap))
        let downTap = UITapGestureRecognizer(target: self, action: #selector(dismissWithTap))
        topArea.addGestureRecognizer(upTap)
        bottomArea.addGestureRecognizer(downTap)
    }
    
    private func setImageFor(button: inout UIButton, type: ToggleButtonType) {
        var image: UIImage
        switch type {
            case .vibro:
                image = SettingsManager.vibrationsEnabled ? UIImage(resource: .on) : UIImage(resource: .off)
            case .sound:
                image = SettingsManager.soundsEnabled ? UIImage(resource: .on) : UIImage(resource: .off)
        }
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
    }

    @objc private func soundTappde(sender: UIButton) {
        SettingsManager.soundsEnabled.toggle()
        SoundManager.shared.playFeedbackSound()
        setImageFor(button: &soundButton, type: .sound)
    }
    
    @objc private func vibroTappde(sender: UIButton) {
        VibroManager.shared.vibro()
        SettingsManager.vibrationsEnabled.toggle()
        setImageFor(button: &vibroButton, type: .vibro)
    }
}


