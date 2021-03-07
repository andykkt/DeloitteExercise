//
//  InputTextField.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import SwiftUI

struct InputTextField: UIViewRepresentable {
    let placeholder: String
    @Binding var text: String
    var onReturn: (() -> Bool)?
    
    private var placeholderColor: UIColor = UIColor.placeholderText// UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
    private var textContentType: UITextContentType?
    private var clearButtonMode: UITextField.ViewMode = .whileEditing
    private var keyboardType: UIKeyboardType = .default
    private var autocorrectionType: UITextAutocorrectionType = .default
    private var autocapitalizationType: UITextAutocapitalizationType = .sentences
    private var foregroundColor: UIColor?
    private var returnKeyType: UIReturnKeyType = .default
    private var font: UIFont = UIFont.preferredFont(forTextStyle: .body)
    private var paddingLeft: CGFloat?
    private var paddingRight: CGFloat?
    
    init(_ placeholder: String, text: Binding<String>, onReturn: (() -> Bool)? = nil) {
        self.placeholder = placeholder
        self._text = text
        self.onReturn = onReturn
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.delegate = context.coordinator
        update(textField)
        textField.becomeFirstResponder()
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        update(uiView)
        if uiView.window != nil,
           !uiView.isFirstResponder
        {
            uiView.becomeFirstResponder()
        }
    }
    
    private func update(_ textField: UITextField) {
        textField.textContentType = textContentType
        textField.clearButtonMode = clearButtonMode
        textField.keyboardType = keyboardType
        textField.autocorrectionType = autocorrectionType
        textField.autocapitalizationType = autocapitalizationType
        textField.font = font
        textField.textColor = foregroundColor
        textField.returnKeyType = returnKeyType
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: placeholderColor,
            .font: font
        ])
        
        if let paddingLeft = paddingLeft {
            textField.paddingLeft = paddingLeft
        }
        
        if let paddingRight = paddingRight {
            textField.paddingRight = paddingRight
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: InputTextField
        init(_ inputTextField: InputTextField) {
            self.parent = inputTextField
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let onReturn = parent.onReturn {
                let shouldReturn = onReturn()
                if shouldReturn {
                    textField.resignFirstResponder()
                }
            }
            return true
        }
    }
}

extension InputTextField {
    
    private func fontWeight(_  weight: Font.Weight) -> UIFont.Weight {
        switch weight {
        case .ultraLight: return .thin
        case .thin: return .light
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        default: return .regular
        }
    }
    
    func flickrFont(style: FlickrFontModifier.TextStyle) -> InputTextField {
        let descriptor = UIFontDescriptor(fontAttributes:
                                            [
                                                UIFontDescriptor.AttributeName.traits: [
                                                    UIFontDescriptor.TraitKey.weight: fontWeight(style.value.weight)
                                                ]
                                            ]
        )
        var view = self
        view.font = UIFont(descriptor: descriptor, size: style.value.size)
        return view
    }
    
    func foregroundColor(_ color: UIColor?) -> InputTextField {
        var view = self
        view.foregroundColor = color
        return view
    }
    
    func font(_ font: UIFont?) -> InputTextField {
        var view = self
        view.font = font ?? UIFont.preferredFont(forTextStyle: .body)
        return view
    }
    
    func textContentType(_ type: UITextContentType) -> InputTextField {
        var view = self
        view.textContentType = type
        return view
    }
    
    func clearButtonMode(_ type: UITextField.ViewMode) -> InputTextField {
        var view = self
        view.clearButtonMode = type
        return view
    }
    
    func keyboardType(_ type: UIKeyboardType) -> InputTextField {
        var view = self
        view.keyboardType = type
        return view
    }
    
    func autocorrectionType(_ type: UITextAutocorrectionType) -> InputTextField {
        var view = self
        view.autocorrectionType = type
        return view
    }
    
    func autocapitalizationType(_ type: UITextAutocapitalizationType) -> InputTextField {
        var view = self
        view.autocapitalizationType = type
        return view
    }
    
    func disableAutocorrection(_ disable: Bool?) -> InputTextField {
        var view = self
        if let disable = disable {
            view.autocorrectionType = disable ? .no : .yes
        } else {
            view.autocorrectionType = .default
        }
        return view
    }
    
    func returnKeyType(_ type: UIReturnKeyType) -> InputTextField {
        var view = self
        view.returnKeyType = type
        return view
    }
    
    func paddingLeft(_ size: CGFloat) -> InputTextField {
        var view = self
        view.paddingLeft = size
        return view
    }
    
    func paddingRight(_ size: CGFloat) -> InputTextField {
        var view = self
        view.paddingRight = size
        return view
    }
}

extension UITextField {
    var paddingLeft: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    var paddingRight: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
}

struct InputTextField_Previews: PreviewProvider {
    static var previews: some View {
        InputTextField("Input", text: .constant("")) {
            
            return true
        }
        .keyboardType(.emailAddress)
        .flickrFont(style: .body)
        .padding()
        .background(Color.gray.opacity(0.5))
        .frame(height: 40)
        
    }
}
