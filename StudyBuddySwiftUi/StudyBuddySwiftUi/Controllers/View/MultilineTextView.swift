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
    
    func makeUIView(context: UIViewRepresentableContext<MultilineTextView>) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.textAlignment = .left
        view.font = UIFont.systemFont(ofSize: 16)
        view.backgroundColor = UIColor.lmuGreen
        view.delegate = context.coordinator
        view.textColor = .white
        
        return view
        
    }
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultilineTextView>) {
        uiView.text = text
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
    }
    
    
    
    
}

