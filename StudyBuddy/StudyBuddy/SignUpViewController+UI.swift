//
//  SignUpViewController+UI.swift
//  StudyBuddy
//
//  Created by Liliane Kabboura on 12.11.19.
//  Copyright © 2019 Manuel Suess. All rights reserved.
//

import UIKit
extension SignUpViewController {
   
    func setupAvatar() {
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true
    }
    func setupFullNameTextField() {
        fullnameViewContainer.layer.borderWidth = 1
        fullnameViewContainer.layer.cornerRadius = 3
        fullnameViewContainer.clipsToBounds = true
        fullnameTextField.borderStyle = .none
        
    }
    func setupEmailTextField() {
        emailContainerView.layer.borderWidth = 1
        emailContainerView.layer.cornerRadius = 3
        emailTextField.clipsToBounds = true
        emailTextField.borderStyle = .none
        
    }
    func setupPasswordTextField() {
        passwordContainerView.layer.borderWidth = 1
        passwordContainerView.layer.cornerRadius = 3
        passwordTextField.clipsToBounds = true
        passwordTextField.borderStyle = .none
        
    }
    func setupSignInButton() {
        let attributedText = NSMutableAttributedString(string: "Already have an accout? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor(white : 0, alpha: 0.65)])
        
        let attributedsubtext = NSMutableAttributedString(string: "Sign In ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.black])
        attributedText.append(attributedsubtext)
        signInButton.setAttributedTitle(attributedsubtext, for: UIControl.State.normal)
               
    }
    func setupSignUpButton() {

       SignUpButton.setTitle("Sign Up", for: UIControl.State.normal)
       SignUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
       SignUpButton.layer.cornerRadius = 5
       SignUpButton.clipsToBounds = true
    }
    
}

