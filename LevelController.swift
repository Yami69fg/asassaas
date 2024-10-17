import UIKit
import SpriteKit
import SnapKit

final class LevelController: UIViewController {
    private var imageBG = UIImageView(image: UIImage(named: "background"))
    private var achiveImage = UIImageView(image: UIImage(named: "bgArray"))
    private var exitButton = UIButton()
    
    
    private var levelStates: [Bool] = Array(repeating: false, count: 12)
    private var lastCompletedLevel: Int = 0
    var exitGameClosure: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = SKView(frame: view.frame)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        loadGameData()
        if levelStates.isEmpty || !levelStates[0] {
            levelStates[0] = true
        }
        addBG()
        setupLevelButtons()
        
        view.addSubview(exitButton)
        
        scaleAnimationsAndFeedbackTo(exitButton)
        exitButton.setImageForAllStates(.closeButton)
        
        exitButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(50)
            make.height.width.equalTo(60)
        }
        
        exitButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
    }
    
    @objc private func dismissController() {
        dismiss(animated: false)
    }
    
    
    func addBG() {
        imageBG.isUserInteractionEnabled = true
        achiveImage.isUserInteractionEnabled = true
        
        imageBG.contentMode = .scaleAspectFill
        achiveImage.contentMode = .scaleAspectFit

        view.addSubview(imageBG)
        view.addSubview(achiveImage)
        
        imageBG.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        achiveImage.snp.makeConstraints { make in
            make.size.equalTo(450)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    func setupLevelButtons() {
        let rows = 3
        let columns = 4
        let buttonSize = 55
        let buttonSpacing = 10
        let buttonsContainer = UIView()
        let totalWidth = (buttonSize * columns) + (buttonSpacing * (columns - 1))
        let totalHeight = (buttonSize * rows) + (buttonSpacing * (rows - 1))

        
        view.addSubview(buttonsContainer)

        buttonsContainer.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalTo(totalWidth)
            make.height.equalTo(totalHeight)
        }

        for index in 0..<rows * columns {
            let button = UIButton(type: .custom)
            button.tag = index + 1
            scaleAnimationsAndFeedbackTo(button)
            button.addTarget(self, action: #selector(levelButtonTapped(_:)), for: .touchUpInside)
            buttonsContainer.addSubview(button)

            let row = index / columns
            let column = index % columns

            button.snp.makeConstraints { make in
                make.width.height.equalTo(buttonSize)

                if column == 0 {
                    make.left.equalTo(buttonsContainer)
                } else {
                    make.left.equalTo(buttonsContainer.subviews[index - 1].snp.right).offset(buttonSpacing)
                }

                if row == 0 {
                    make.top.equalTo(buttonsContainer)
                } else {
                    make.top.equalTo(buttonsContainer.subviews[index - columns].snp.bottom).offset(buttonSpacing + 10)
                }
            }
            
            configureButton(button, index: index)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "LEVELS"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .cyan
        
        titleLabel.font = UIFont(name: "Ministro", size: 64)
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(achiveImage.snp.top)
        }
    }

    private func configureButton(_ button: UIButton, index: Int) {
        let levelIndex = index + 1
        
        if levelStates[index] {
            button.setImage(UIImage(named: "level"), for: .normal)
            let levelLabel = UILabel()
            levelLabel.text = "\(levelIndex)"
            levelLabel.textColor = .white
            levelLabel.textAlignment = .center
            levelLabel.font = UIFont(name: "Ministro", size: 28)
            button.addSubview(levelLabel)

            levelLabel.snp.makeConstraints { make in
                make.center.equalTo(button)
            }
        } else {
            button.setImage(UIImage(named: "lockLevel"), for: .normal)
            let levelLabel = UILabel()
            levelLabel.text = ""
            levelLabel.textColor = .clear
            levelLabel.textAlignment = .center
            button.addSubview(levelLabel)

            levelLabel.snp.makeConstraints { make in
                make.center.equalTo(button)
            }
        }
    }

    @objc func levelButtonTapped(_ sender: UIButton) {
        let selectedLevel = sender.tag
        if levelStates[selectedLevel - 1] {
            openGameViewController(level: selectedLevel)
        }   
    }

    private func openGameViewController(level: Int) {
        let gameViewController = GameController()
        gameViewController.exitGameClosure = {
            self.dismiss(animated: false) {
                self.exitGameClosure?()
            }
        }
        gameViewController.selectedLevel = level
        gameViewController.modalPresentationStyle = .overFullScreen
        present(gameViewController, animated: true)
    }

    func completeLevel(_ level: Int) {
        if level <= levelStates.count {
            levelStates[level - 1] = true
            if level < levelStates.count && !levelStates[level] {
                levelStates[level] = true
            }

            lastCompletedLevel = level
            saveGameData()
            saveCompletedLevel(level)
        }
        updateLevelButtons()
    }
    
    private func saveCompletedLevel(_ level: Int) {
        let defaults = UserDefaults.standard
        var completedLevels = defaults.array(forKey: "completedLevels") as? [Int] ?? []
        
        if !completedLevels.contains(level) {
            completedLevels.append(level)
            defaults.set(completedLevels, forKey: "completedLevels")
        }
    }

    func updateLevelButtons() {
        guard let buttonsContainer = view.subviews.first(where: { $0 is UIView && $0.subviews.first is UIButton }) else {
            return
        }

        for index in 0..<levelStates.count {
            if let button = buttonsContainer.subviews.first(where: { ($0 as? UIButton)?.tag == index + 1 }) as? UIButton {
                configureButton(button, index: index)
            }
        }
    }

    private func saveGameData() {
        let defaults = UserDefaults.standard
        defaults.set(levelStates, forKey: "levelStates")
        defaults.set(lastCompletedLevel, forKey: "lastCompletedLevel")
    }

    private func loadGameData() {
        let defaults = UserDefaults.standard

        if let savedLevelStates = defaults.array(forKey: "levelStates") as? [Bool] {
            levelStates = savedLevelStates
        } else {
            levelStates[0] = true
        }

        if let completedLevels = defaults.array(forKey: "completedLevels") as? [Int] {
            for level in completedLevels {
                if level > 0 && level <= levelStates.count {
                    levelStates[level - 1] = true
                }
            }
        }

        lastCompletedLevel = defaults.integer(forKey: "lastCompletedLevel")
    }
    
    
}
