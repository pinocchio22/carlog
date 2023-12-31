import UIKit

extension UITextField {
    func customTextField(placeholder: String, textColor: UIColor, font: UIFont, alignment: NSTextAlignment) {
        self.placeholder = placeholder
        self.font = font
        self.sizeToFit()
        self.textAlignment = alignment
        self.textColor = textColor
    }
    
    func loginCustomTextField(placeholder: String, textColor: UIColor, font: UIFont, alignment: NSTextAlignment, paddingView: UIView) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ])
        self.font = font
        self.sizeToFit()
        self.textAlignment = alignment
        self.textColor = textColor
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.layer.cornerRadius = Constants.cornerRadius
        self.backgroundColor = .white
        self.leftView = paddingView
        self.leftViewMode = .always
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
    }
    
    func mypageCustomTextField(placeholder: String, textColor: UIColor, font: UIFont, alignment: NSTextAlignment) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = UIColor.systemGray.cgColor
        border.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width - 40, height: 1)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.font = font
        self.sizeToFit()
        self.textAlignment = alignment
        self.textColor = textColor
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.borderStyle = .none
    }
    
    //새롭게 커스텀한 히스토리페이지 텍스트필드
    func historyNewCustomTextField(placeholder: NSAttributedString, font: UIFont, textColor: UIColor, alignment: NSTextAlignment, paddingView: UIView, keyboardType: UIKeyboardType) {
        self.attributedPlaceholder = placeholder
        self.font = font
        self.sizeToFit()
        self.textAlignment = alignment
        self.textColor = textColor
        self.heightAnchor.constraint(equalToConstant: font.lineHeight + Constants.horizontalMargin * 2).isActive = true
        self.layer.cornerRadius = Constants.cornerRadius
        self.backgroundColor = .backgroundCoustomColor
        self.rightView = paddingView
        self.rightViewMode = .always
        self.keyboardType = keyboardType
    }
}
