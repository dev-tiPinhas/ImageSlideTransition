import Kingfisher
import Foundation
import UIKit

final class SlideShowView: UIView {

    // MARK: Constants Properties
    
    private enum Constants {
        static let animationDuration: Double = 8
        static let imageTransitionDuration: TimeInterval = 0.25
        static let minimumSlideshowElements: Int = 3
    }

    private enum SlideshowImageAnimationMode {
        case firstToSecond
        case secondToFirst
    }

    // MARK: UI Properties
    
    private let firstImageView = UIImageView()
    private let secondImageView = UIImageView()
    var backgroundImages = [String]() {
        didSet {
            configure()
        }
    }
    var fallbackBackgroundImage: String? {
        didSet {
            configure()
        }
    }
    private var currentIndex: Int = 0
    private var currentImageTransition: SlideshowImageAnimationMode = .firstToSecond
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
            firstImageView,
            secondImageView
        )

        firstImageView.contentMode = UIView.ContentMode.scaleAspectFill
        secondImageView.contentMode = UIView.ContentMode.scaleAspectFill
        firstImageView.clipsToBounds = true
        secondImageView.clipsToBounds = true
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            firstImageView.topAnchor.constraint(equalTo: topAnchor),
            firstImageView.leftAnchor.constraint(equalTo: leftAnchor),
            firstImageView.widthAnchor.constraint(equalTo: widthAnchor),
            firstImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            secondImageView.topAnchor.constraint(equalTo: topAnchor),
            secondImageView.leftAnchor.constraint(equalTo: leftAnchor),
            secondImageView.widthAnchor.constraint(equalTo: widthAnchor),
            secondImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func configure() {
        if backgroundImages.count >= Constants.minimumSlideshowElements {
            setImage(imageView: firstImageView, urlString: backgroundImages[currentIndex], alpha: 1)
            updateCurrentIndex()
            setImage(imageView: secondImageView, urlString: backgroundImages[currentIndex], alpha: 0)
            performTransition()
        } else {
            setImage(imageView: firstImageView, urlString: fallbackBackgroundImage, alpha: 1)
        }
    }

    private func performTransition() {
        crossFade(firstImageView: firstImageView, secondImageView: secondImageView)
    }
    
    private func crossFade(firstImageView: UIImageView, secondImageView: UIImageView) {
        
        UIView.animateKeyframes(
            withDuration: Constants.animationDuration,
            delay: 0,
            options: [],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                    firstImageView.alpha = 1
                    secondImageView.alpha = 0
                }
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.125) {
                    firstImageView.alpha = 0.5
                    secondImageView.alpha = 0
                }
                UIView.addKeyframe(withRelativeStartTime: 0.375, relativeDuration: 0.125) {
                    firstImageView.alpha = 0.25
                    secondImageView.alpha = 0
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.125) {
                    firstImageView.alpha = 0
                    secondImageView.alpha = 0.25
                }
                UIView.addKeyframe(withRelativeStartTime: 0.625, relativeDuration: 0.125) {
                    firstImageView.alpha = 0
                    secondImageView.alpha = 0.5
                }
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                    firstImageView.alpha = 0
                    secondImageView.alpha = 1
                }
            },
            completion: { [weak self] completed in
                guard completed == true else { return }
                self?.updateAnimationContent()
            }
        )
    }
    
    private func updateSlideshowContent() {
        switch currentImageTransition {
        case .firstToSecond:
            setImage(imageView: secondImageView, urlString: backgroundImages[currentIndex])
            crossFade(
                firstImageView: firstImageView,
                secondImageView: secondImageView
            )
            
        case .secondToFirst:
            setImage(imageView: firstImageView, urlString: backgroundImages[currentIndex])
            crossFade(
                firstImageView: secondImageView,
                secondImageView: firstImageView
            )
        }
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
                    imageView.image = nil
                }
            }
        }
    }
    
    private func updateAnimationContent() {
        currentImageTransition = currentImageTransition == .firstToSecond
        ? .secondToFirst
        : .firstToSecond
        updateCurrentIndex()
        updateSlideshowContent()
    }
    
    func pauseAnimation() {
        firstImageView.layer.removeAllAnimations()
        secondImageView.layer.removeAllAnimations()
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
