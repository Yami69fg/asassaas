import UIKit
import SpriteKit
import SnapKit
import SafariServices

final class MenuController: UIViewController {
    
    private var background = UIImageView(image: .background)
    private var mainBall = UIImageView(image: .bomb)
    private var logo = UIImageView(image: .logo)
    var privacyButton = UIButton()
    var playButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = SKView(frame: view.frame)
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(background)
        view.addSubview(mainBall)
        view.addSubview(logo)
        view.addSubview(privacyButton)
        view.addSubview(playButton)
        
        configureBackground()
        configureMainBall()
        configureLogo()
        configurePrivacyButton()
        configurePlayButton()
    }
    
    private func configureBackground() {
        background.contentMode = .scaleAspectFill
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureMainBall() {
        mainBall.contentMode = .scaleAspectFit
        mainBall.snp.makeConstraints { make in
            make.width.equalTo(800)
            make.leading.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview().offset(-80)
        }
    }

    private func configureLogo() {
        logo.contentMode = .scaleAspectFit
        logo.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.centerX.equalTo(mainBall.snp.centerX)
            make.centerY.equalTo(mainBall.snp.centerY)
        }
    }

    private func configurePrivacyButton() {
        privacyButton.setImageForAllStates(.privacyButton)
        privacyButton.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.trailing.equalToSuperview().inset(25)
            make.top.equalTo(view.snp.top).offset(45)
        }
        scaleAnimationsAndFeedbackTo(privacyButton)
        privacyButton.addTarget(self, action: #selector(openPrivacy), for: .touchUpInside)
    }
    
    private func configurePlayButton() {
        playButton.setImageForAllStates(.playButton)
        playButton.snp.makeConstraints { make in
            make.top.equalTo(mainBall.snp.bottom).offset(-60)
            make.centerX.equalToSuperview()
            make.width.equalTo(290)
            make.height.equalTo(220)
        }
        scaleAnimationsAndFeedbackTo(playButton)
        playButton.addTarget(self, action: #selector(playGame), for: .touchUpInside)
    }
    
    @objc private func openPrivacy() {
        guard let url = URL(string: "https://www.example.com") else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
    
    @objc private func playGame() {
        let gameController = LevelController()
        gameController.modalPresentationStyle = .overFullScreen
        present(gameController, animated: true)
    }
}
