import UIKit
import SpriteKit
import SnapKit

final class LoadingController: UIViewController {
    
    private var background = UIImageView(image: .background)
    private var loadingBall = UIImageView(image: .point)
    private var loading = UIImageView(image: .loadingLabel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = SKView(frame: view.frame)
        
        setupUI()
        startLoading()
    }
    
    private func setupUI() {
        configureBackground()
        configureLoadingBall()
        configureLoadingLabel()
    }

    private func configureBackground() {
        view.addSubview(background)
        background.contentMode = .scaleAspectFill
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configureLoadingBall() {
        view.addSubview(loadingBall)
        loadingBall.contentMode = .scaleAspectFit
        loadingBall.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }

    private func configureLoadingLabel() {
        view.addSubview(loading)
        loading.contentMode = .scaleAspectFit
        loading.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loadingBall.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(80)
        }
    }

    func startLoadingAnimation() {
        animateLoadingBall()
        animateLoadingLabel()
    }

    private func animateLoadingBall() {
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: { [weak self] in
            self?.loadingBall.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        })
    }

    private func animateLoadingLabel() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: { [weak self] in
            self?.loading.alpha = 0.0
        })
    }
    
    private func startLoading() {
        startLoadingAnimation()
        SoundManager.shared.initPlayer()
        transitionAfterDelay()
    }

    private func transitionAfterDelay() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self?.goToNextViewController()
        }
    }

    private func goToNextViewController() {
        let gameplayController = MenuController()
        gameplayController.modalPresentationStyle = .overFullScreen
        present(gameplayController, animated: true)
    }
}
