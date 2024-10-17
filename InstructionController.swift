import UIKit

class InstructionController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font1Name = "Ministro"
        let background = UIImage(named: "BGBlack")
        let backgroundImageView = UIImageView(image: background)
        backgroundImageView.frame = view.bounds
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.7
        backgroundImageView.layer.zPosition = 20
        view.addSubview(backgroundImageView)
        
        let backgroundImage = UIImage(named: "settingsBG")
        let backgrounds = UIImageView(image: backgroundImage)
        backgrounds.layer.zPosition = 20
        view.addSubview(backgrounds)
        
        backgrounds.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(backgrounds.snp.width)
        }
        
        let instruction = UILabel()
        instruction.layer.zPosition = 21
        let attributedText = NSMutableAttributedString(string: """
        You need to connect
        two points
        without hitting the bombs.
        You must remember where
        the bombs are located.
        """)
        
        attributedText.addAttributes([.font: UIFont(name: font1Name, size: 34) ?? UIFont.systemFont(ofSize: 26), .foregroundColor: UIColor.white], range: NSRange(location: 0, length: attributedText.length))
        
        instruction.attributedText = attributedText
        instruction.textAlignment = .center
        instruction.numberOfLines = 0
        instruction.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(instruction)
        
        instruction.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        let instructionTitle = UILabel()
        instructionTitle.layer.zPosition = 21
        let attributedTex = NSMutableAttributedString(string: """
        How to play?
        """)
        
        attributedTex.addAttributes([.font: UIFont(name: font1Name, size: 42) ?? UIFont.systemFont(ofSize: 26), .foregroundColor: UIColor.cyan], range: NSRange(location: 0, length: attributedTex.length))
        
        instructionTitle.attributedText = attributedTex
        instructionTitle.textAlignment = .center
        instructionTitle.numberOfLines = 0
        instructionTitle.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(instructionTitle)
        
        instructionTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backgrounds.snp.top)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        let nextButton = UIButton(type: .custom)
        nextButton.setImage(UIImage(named: "closeButton"), for: .normal)
        nextButton.backgroundColor = .clear
        nextButton.layer.zPosition = 21
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        view.addSubview(nextButton)

        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(instruction.snp.bottom).offset(55)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }

    }
    
    @objc func handleCloseButtonTap() {
        dismiss(animated: true, completion: nil)
    }
}
