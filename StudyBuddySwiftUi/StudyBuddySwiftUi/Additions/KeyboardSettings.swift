//
//  KeyboardSettings.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 19.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//
     import SwiftUI

     final class KeyboardResponder: ObservableObject {
         private var notificationCenter: NotificationCenter
         @Published private(set) var currentHeight: CGFloat = 0

         init(center: NotificationCenter = .default) {
             notificationCenter = center
             notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
             notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
         }

         deinit {
             notificationCenter.removeObserver(self)
         }

         @objc func keyBoardWillShow(notification: Notification) {
             if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                 currentHeight = keyboardSize.height
                
             }
         }

         @objc func keyBoardWillHide(notification: Notification) {
             currentHeight = 0
         }

}


extension UIViewController  {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


