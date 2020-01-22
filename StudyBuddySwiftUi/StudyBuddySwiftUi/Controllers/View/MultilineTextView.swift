//
//  MultilineTextView.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 22.01.20.
//  Copyright © 2020 Annika Jung. All rights reserved.
//

import SwiftUI

struct MultilineTextView: UIViewRepresentable {
    
    typealias UIViewType = UITextView
    @Binding var text: String
    var placeHolder : String
    
    func makeUIView(context: UIViewRepresentableContext<MultilineTextView>) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.textAlignment = .left
        view.font = UIFont.systemFont(ofSize: 16)
        view.backgroundColor = UIColor.lmuGreen
        view.delegate = context.coordinator
        view.textColor = .placeholderText
        view.text = placeHolder
        
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultilineTextView>) {
        if text.isEmpty{
            uiView.textColor = .placeholderText
            uiView.text = placeHolder
        }else{
            uiView.text = text
            uiView.textColor = .white
            
        }
    }
    
    func makeCoordinator() -> MultilineTextView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var control: MultilineTextView
        
        init(_ control: MultilineTextView) {
            self.control = control
        }
        
        func textViewDidChange(_ textView: UITextView) {
            control.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.placeholderText {
                textView.text = nil
                textView.textColor = UIColor.white
            }
        }
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = control.placeHolder
                textView.textColor = UIColor.placeholderText
            }
        }
    }
}
