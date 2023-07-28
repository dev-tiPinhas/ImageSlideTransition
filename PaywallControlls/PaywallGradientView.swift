import Foundation
import UIKit

final class PaywallGradientView: UIView {
    
    // MARK: Constants Properties
    
    private enum Constants {
        static let layer0Colors = [
            UIColor.black.cgColor,
            UIColor.black.withAlphaComponent(0).cgColor
            //Theme.UpsellPaywall.gradientLayerZeroColor.cgColor,
            //Theme.UpsellPaywall.gradientLayerZeroColor.withAlphaComponent(0).cgColor
        ]
        static let layer1Colors = [
            UIColor.black.cgColor,
            UIColor.black.withAlphaComponent(0.08).cgColor
            //Theme.UpsellPaywall.gradientLayerOneColor.cgColor,
            //Theme.UpsellPaywall.gradientLayerOneColor.withAlphaComponent(0.08).cgColor
        ]
        static let layer2Colors = [
            UIColor.black.cgColor,
            UIColor.init(red: 0.43, green: 0.33, blue: 0.86, alpha: 1.0).cgColor,
            UIColor.init(red: 0.43, green: 0.33, blue: 0.86, alpha: 1.0).cgColor,
            UIColor.init(red: 0.43, green: 0.33, blue: 0.86, alpha: 0.0).cgColor
            //Theme.UpsellPaywall.gradientLayerTwoFirstColor.cgColor,
            //Theme.UpsellPaywall.gradientLayerTwoSecondColor.cgColor,
            //Theme.UpsellPaywall.gradientLayerTwoSecondColor.cgColor,
            //Theme.UpsellPaywall.gradientLayerTwoSecondColor.withAlphaComponent(0).cgColor
        ]
    }
    
    // MARK: UI Properties
    
    private let layer0 = CAGradientLayer()
    private let layer1 = CAGradientLayer()
    private let layer2 = CAGradientLayer()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupGradientView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer0.position = center
        layer0.bounds = bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
        
        layer1.position = center
        layer1.bounds = bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
        
        layer2.position = center
        layer2.bounds = bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
    }
    
    // MARK: - UI Methods
    
    private func setupGradientView() {
        alpha = 0.8
        
        layer0.colors = Constants.layer0Colors
        layer0.locations = [0.52, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(
            CGAffineTransform(a: 0.24, b: -1.46, c: 4.08, d: 2.94, tx: -1.68, ty: -0.01)
        )
        layer.addSublayer(layer0)
        
        layer1.colors = Constants.layer1Colors
        layer1.locations = [0.36, 1]
        layer1.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer1.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer1.transform = CATransform3DMakeAffineTransform(
            CGAffineTransform(a: 1.49, b: -0.04, c: 0.03, d: 0.84, tx: -0.51, ty: -0.18)
        )
        layer.addSublayer(layer1)
        
        layer2.colors = Constants.layer2Colors
        layer2.locations = [0.01, 1, 1, 1]
        layer2.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer2.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer2.transform = CATransform3DMakeAffineTransform(
            CGAffineTransform(a: 1.18, b: -0.65, c: -0.65, d: 2.48, tx: 0.53, ty: -0.54)
        )
        layer.addSublayer(layer2)
    }
}
