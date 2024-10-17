import UIKit
import SpriteKit
import GameplayKit
import SnapKit

final class GameController: UIViewController {
    var selectedLevel: Int = 1
    var targetScore: Int = 0
    var Bg: String = ""
    
    private weak var scene: GameScene?
    var levelController: LevelController?
    var exitGameClosure: (() -> Void)?
    
    private var instButton = UIButton()
    private var pauseButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGameData()
        setupGameView()
        setupButtons()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func loadGameData() {
        if let gameData = getGameData(for: selectedLevel) {
            Bg = gameData.Bg
            targetScore = gameData.targetScore
        }
    }

    private func setupGameView() {
        self.view = SKView(frame: view.frame)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let skView = self.view as? SKView {
            let gameScene = GameScene(size: skView.bounds.size, level: selectedLevel, bg: Bg, targetScore: targetScore)
            self.scene = gameScene
            gameScene.gController = self
            gameScene.scaleMode = .aspectFill
            skView.presentScene(gameScene)
            skView.ignoresSiblingOrder = true
        }
    }
    
    private func setupButtons() {
        configureInstButton()
        configurePauseButton()
    }
    
    private func configurePauseButton() {
        view.addSubview(pauseButton)
        scaleAnimationsAndFeedbackTo(pauseButton)
        pauseButton.setImageForAllStates(.pauseButton)
        
        pauseButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(50)
            make.height.width.equalTo(55)
        }
        
        pauseButton.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
    }

    private func configureInstButton() {
        view.addSubview(instButton)
        scaleAnimationsAndFeedbackTo(instButton)
        instButton.setImageForAllStates(.instButton)
        
        instButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(110)
            make.height.width.equalTo(55)
        }
        
        instButton.addTarget(self, action: #selector(instTapped), for: .touchUpInside)
    }

    @objc private func pauseTapped() {
        let pauseController = PauseController()
        pauseController.modalPresentationStyle = .overFullScreen
        pauseController.exitGameClosure = {
            self.dismiss(animated: true)
        }
        present(pauseController, animated: false)
    }
    
    @objc private func instTapped() {
        if let skView = self.view as? SKView,
           let scene = skView.scene as? GameScene {
            scene.showInstruction()
        }
    }

    private func saveCompletedLevel() {
        let defaults = UserDefaults.standard
        var completedLevels = defaults.array(forKey: "completedLevels") as? [Int] ?? []
        
        if !completedLevels.contains(selectedLevel) {
            completedLevels.append(selectedLevel)
            defaults.set(completedLevels, forKey: "completedLevels")
        }
    }

    func gameOver(score: Int, win: Bool) {
        handleGameOver(score: score, win: win)
    }
    
    private func handleGameOver(score: Int, win: Bool) {
        if UserDefaults.standard.integer(forKey: "lastCompletedLevel") <= selectedLevel && win == true {
            let levelController = LevelController()
            levelController.completeLevel(selectedLevel)
        }
        
        let gameOverController = GameOverController(score: score, win: win)
        gameOverController.modalPresentationStyle = .overFullScreen
        
        gameOverController.exitGameClosure = {
            self.dismiss(animated: false) {
                self.levelController?.updateLevelButtons()
                self.exitGameClosure?()
            }
        }
        
        gameOverController.restartTheGameClosure = {
            self.scene?.restart()
        }
        
        present(gameOverController, animated: false)
    }
}
