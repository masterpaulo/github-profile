
import UIKit

extension UIView {
    public func fixInView(_ container: UIView!) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }

    @IBInspectable public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }

    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable public var isOval: Bool {
        get {
            return self.isOval
        }
        set {
            clipsToBounds = true
            if newValue {
                self.cornerRadius = self.bounds.width / 2
            }
        }
    }
}

public extension UIView {
    func gradientColor(with start: UIColor, end: UIColor) -> CAGradientLayer {
        let gradientLayer       = CAGradientLayer()
        gradientLayer.frame     = self.bounds
        gradientLayer.colors    = [start.cgColor, end.cgColor]
        return gradientLayer
    }
    
    func roundCorners(corners:UIRectCorner, cornerRadius: Double) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners:corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}

