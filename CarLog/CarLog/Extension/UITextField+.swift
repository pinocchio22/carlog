import UIKit

extension UITextField {
    func customTextField(placeholder: String, textColor: UIColor, font: UIFont, alignment: NSTextAlignment){
        self.placeholder = placeholder
        self.font = font
        self.sizeToFit()
        self.textAlignment = alignment
        self.textColor = textColor
    }
    
    func loginCustomTextField(placeholder: String, textColor: UIColor, font: UIFont, alignment: NSTextAlignment, paddingView: UIView){
        self.placeholder = placeholder
        self.font = font
        self.sizeToFit()
        self.textAlignment = alignment
        self.textColor = textColor
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.layer.cornerRadius = 15
        self.backgroundColor = .white
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
