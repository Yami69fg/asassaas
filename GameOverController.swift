import UIKit
import SnapKit

final class GameOverController: UIViewController {
    private var score: Int
    private var win: Bool
    
    
    private var shadow = UIImageView(image: .shadow)
    private var overImage = UIImageView()
    private var candyImage = UIImageView(image: .candy)
    private var gameOverImage = UIImageView(image: .settingsBG)
    
    private var scoreLabel = UILabel()
    private var scoreL = UILabel()
    private var bestScoreLabel = UILabel()
    private var bestScoreL = UILabel()
    
    var exitButton = UIButton()
    var restartButton = UIButton()
    
    var exitGameClosure: (() -> Void)?
    var restartTheGameClosure: (() -> ())?
    
    init(score: Int, win:Bool) {
        self.score = score
        self.win = win
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if win {
            overImage = UIImageView(image: .youWin)
        } else {
            overImage = UIImageView(image: .tryNow)
        }
        addElements()
        
        if score > SettingsManager.bestScore {
            SettingsManager.bestScore = score
        }
        
        scoreL.text = "\(score)"
        bestScoreL.text = "\(SettingsManager.bestScore)"
        
        exitButton.addTarget(self, action: #selector(exitToMenu), for: .touchUpInside)
        restartButton.addTarget(self, action: #selector(restartTheGame), for: .touchUpInside)
        scaleAnimationsAndFeedbackTo(exitButton)
        scaleAnimationsAndFeedbackTo(restartButton)
        
        
    }
    
    @objc private func exitToMenu() {
        self.dismiss(animated: false) {
            self.exitGameClosure?()
        }
    }
    
    @objc private func restartTheGame() {
        restartTheGameClosure?()
        dismiss(animated: false)
    }
    
    
    private func addElements() {
        view.addSubview(shadow)
        view.addSubview(candyImage)
        view.addSubview(gameOverImage)
        view.addSubview(overImage)
        view.addSubview(exitButton)
        view.addSubview(restartButton)
        gameOverImage.addSubview(scoreLabel)
        gameOverImage.addSubview(bestScoreLabel)
        gameOverImage.addSubview(scoreL)
        gameOverImage.addSubview(bestScoreL)
        
        shadow.alpha = 0.4
        shadow.contentMode = .scaleAspectFill
        candyImage.contentMode = .scaleAspectFit
        gameOverImage.contentMode = .scaleAspectFit
        overImage.contentMode = .scaleAspectFit
        exitButton.setImageForAllStates(.exitButton)
        restartButton.setImageForAllStates(.restartButton)
        
        scoreLabel.text = "SCORE"
        bestScoreLabel.text = "BEST"
        scoreLabel.font = UIFont(name: "Ministro", size: 26)
        bestScoreLabel.font = UIFont(name: "Ministro", size: 26)
        scoreLabel.textColor = .white
        bestScoreLabel.textColor = .white
        
        scoreL.font = UIFont(name: "Ministro", size: 26)
        bestScoreL.font = UIFont(name: "Ministro", size: 26)
        scoreL.textColor = UIColor(red: 1, green: 0.984, blue: 0.325, alpha: 1)
        bestScoreL.textColor = UIColor(red: 1, green: 0.984, blue: 0.325, alpha: 1)
        
        shadow.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        overImage.snp.makeConstraints { make in
            make.width.equalTo(overImage.snp.height)
            make.leading.trailing.equalToSuperview().inset(25)
            make.center.equalToSuperview()
        }
        
        candyImage.snp.makeConstraints { make in
            make.width.equalTo(candyImage.snp.height)
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalTo(overImage.snp.centerY).offset(-10)
        }
        
        gameOverImage.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(180)
            make.centerX.equalToSuperview()
            make.top.equalTo(overImage.snp.bottom).offset(-70)
        }
        
        restartButton.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.centerX.equalToSuperview().offset(-40)
            make.centerY.equalTo(gameOverImage.snp.bottom).offset(-8)
        }
        
        exitButton.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.centerX.equalToSuperview().offset(40)
            make.centerY.equalTo(restartButton)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-5)
            make.centerX.equalToSuperview().offset(-20)
        }
        
        bestScoreLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview().offset(-20)
        }
        
        scoreL.snp.makeConstraints { make in
            make.centerY.equalTo(scoreLabel)
            make.leading.equalTo(scoreLabel.snp.trailing).offset(10)
        }
        
        bestScoreL.snp.makeConstraints { make in
            make.centerY.equalTo(bestScoreLabel)
            make.leading.equalTo(bestScoreLabel.snp.trailing).offset(10)
        }
    }
}
