import UIKit

// 키보드 화면 탭 동작시 반응.
extension UIViewController{
    func keyBoardHide(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyBoard(){
        view.endEditing(true)
    }
}

// addSubView 커스텀
extension UIView {
    func addSubViews(_ views : [UIView]) {
        _ = views.map{self.addSubview($0)}
    }
}

