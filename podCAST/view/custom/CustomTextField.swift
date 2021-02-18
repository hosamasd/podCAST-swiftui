////
////  CustomTextField.swift
////  podCAST
////
////  Created by hosam on 2/14/21.
////
//
//import SwiftUI
//
//struct CustomTextField:  UIViewRepresentable {
//    typealias UIViewType = UITextField
//
//    @Binding var becomeFirstResponder: Bool
//    @Binding var text: String
//
//    func makeUIView(context: Context) -> UITextField {
//        let v = UITextField()
//        v.text=text
//        
//        return v
//    }
//    
//    func updateUIView(_ textField: UITextField, context: Context) {
//        if self.becomeFirstResponder {
//            DispatchQueue.main.async {
//                textField.becomeFirstResponder()
//                self.becomeFirstResponder = false
//            }
//        }
//    }
//}
