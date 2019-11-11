//
//  ViewController.swift
//  StudyBuddy
//
//  Created by Manuel Suess on 08.11.19.
//  Copyright © 2019 Manuel Suess. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var EnterUsernameAndPasswordLabel: UILabel!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var OrLabel: UILabel!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var SignupButton: UIButton!
    override func viewDidLoad() {
     
        super.viewDidLoad()
        SetupUI()
    }
    
    func SetupUI() {
            LoginButton.setTitle("Log In", for: UIControl.State.normal)
            LoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            LoginButton.layer.cornerRadius = 5
            LoginButton.clipsToBounds = true
        
        SignupButton.setTitle("Sign Up", for: UIControl.State.normal)
        SignupButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        SignupButton.layer.cornerRadius = 5
        SignupButton.clipsToBounds = true
        
        }
    
        
      
        }
        

    

        
        
    




