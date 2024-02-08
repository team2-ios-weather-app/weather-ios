import UIKit

extension UIView {
    func addSubViews(_ views : [UIView]) {
        _ = views.map{self.addSubview($0)}
    }
}
