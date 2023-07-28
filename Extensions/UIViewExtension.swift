import Foundation
import UIKit

extension UIView {
    @discardableResult
    func addAutoLayoutSubviews(_ subviews: UIView...) -> UIView {
        for subview in subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
        return self
    }
}
