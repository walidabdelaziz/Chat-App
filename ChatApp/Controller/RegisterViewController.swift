//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Walid  on 7/13/20.
//  Copyright © 2020 Walid . All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if  let email = emailTextField.text, let password = passwordTextField.text {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error{
                print("There is an error:\(err)")
        
                // popover message if email or password is empty
                if email.isEmpty == true || password.isEmpty == true{
                    let alert = UIAlertController(title: "Error", message: "Please fill the missing fields", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                // popover message if  password is less than 6 digits

                let alert = UIAlertController(title: "Error", message: "Password must be at least 6 characters", preferredStyle: .alert)
                                                  alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                                                  self.present(alert, animated: true, completion: nil)
            }else {
                
                // Navigate to chat screen

                self.performSegue(withIdentifier: K.registerSegue, sender: self)
            }
        }
    }
    }
    
}
