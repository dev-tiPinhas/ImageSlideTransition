import Kingfisher
import Foundation
import UIKit

final class PaywallSlideShowView: UIView {

    // MARK: Constants Properties
    
    private enum Constants {
        static let animationDuration: Double = 4
        static let imageTransitionDuration: TimeInterval = 0.25
        static let minimumSlideshowElements: Int = 3
    }

    // MARK: UI Properties
    
    private let backgroundImageView = UIImageView()
    private var backgroundImages = [String]()
    private var fallbackBackgroundImage: String?
    private var currentIndex: Int = 0
    private var previousIndex: Int {
        return currentIndex - 1 < 0 ? backgroundImages.count - 1 : currentIndex - 1
    }

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubviews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UI Methods
    
    private func setupSubviews() {
        addAutoLayoutSubviews(
            backgroundImageView
        )

        backgroundImageView.contentMode = UIView.ContentMode.scaleAspectFill
        backgroundImageView.clipsToBounds = true
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func configure() {
        if backgroundImages.count >= Constants.minimumSlideshowElements {
            setImage(imageView: backgroundImageView, urlString: backgroundImages[currentIndex], alpha: backgroundImageView.alpha)
            performTransition()
            updateCurrentIndex()
        } else {
            setImage(imageView: backgroundImageView, urlString: fallbackBackgroundImage, alpha: 1)
        }
    }

    func setData(backgroundImages: [String]) {
        self.backgroundImages = backgroundImages
        configure()
    }

    func setData(fallbackBackgroundImage: String) {
        self.fallbackBackgroundImage = fallbackBackgroundImage
        configure()
    }

    private func performTransition() {
        crossFade(backgroundImageView: backgroundImageView)
    }
    
    private func crossFade(backgroundImageView: UIImageView) {
        
        UIView.animateKeyframes(
            withDuration: Constants.animationDuration,
            delay: 0,
            options: [],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.50) {
                    backgroundImageView.alpha = 1
                }
                UIView.addKeyframe(withRelativeStartTime: 0.50, relativeDuration: 0.25) {
                    backgroundImageView.alpha = 0.5
                }
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.15) {
                    backgroundImageView.alpha = 0.25
                }
                UIView.addKeyframe(withRelativeStartTime: 0.90, relativeDuration: 0.10) {
                    backgroundImageView.alpha = 0.1
                }
            },
            completion: { [weak self] completed in
                guard completed == true else { return }
                self?.updateAnimationContent()
            }
        )
    }
    
    private func setImage(imageView: UIImageView, urlString: String?, alpha: CGFloat? = nil) {
        if let urlString = urlString,
           let url = URL(string: urlString) {
            
            if let alpha = alpha {
                imageView.alpha = alpha
            }
            
            let options: [KingfisherOptionsInfoItem] = [.forceRefresh]
            
            let resource: Kingfisher.KF.ImageResource = Kingfisher.KF.ImageResource(
                downloadURL: url,
                cacheKey: nil
            )
            
            Kingfisher.KingfisherManager.shared.retrieveImage(with: resource, options: options) { result in
                switch result {
                case .success(let result):
                    imageView.image = result.image
                case .failure(_):
                    return
                }
            }
        }
    }
    
    private func updateAnimationContent() {
        configure()
        UIView.animateKeyframes(
            withDuration: Constants.animationDuration,
            delay: 0,
            options: [],
            animations: { [weak self] in
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.50) {
                    self?.backgroundImageView.alpha = 0.1
                }
                UIView.addKeyframe(withRelativeStartTime: 0.50, relativeDuration: 0.25) {
                    self?.backgroundImageView.alpha = 0.25
                }
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.15) {
                    self?.backgroundImageView.alpha = 0.50
                }
                UIView.addKeyframe(withRelativeStartTime: 0.90, relativeDuration: 0.10) {
                    self?.backgroundImageView.alpha = 0.1
                }
            },
            completion: { [weak self] completed in
                guard completed == true, let imageView = self?.backgroundImageView else { return }
                self?.crossFade(backgroundImageView: imageView)
            }
        )
    }
    
    func pauseAnimation() {
        backgroundImageView.layer.removeAllAnimations()
    }
    
    func resumeAnimation() {
        updateAnimationContent()
    }
    
    // MARK: - Auxiliar Methods
    
    private func updateCurrentIndex() {
        if backgroundImages.count == currentIndex + 1 {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
    }
}
