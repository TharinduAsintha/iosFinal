//
//  SignUpViewController.swift
//  WijekoonWHMCB-COBSCCOMP191P-006
//
//  Created by Chathura Wijekoon on 9/18/20.
//  Copyright © 2020 Chathura Wijekoon. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func btnClose(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func backToSignIn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true){
        }
    }
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var roleSelector: UISegmentedControl!
    
    @IBAction func btnSignUp(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        print(email)
        print(password)
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error {
                print(err)
                return
            }
            self.db.collection("users").addDocument(data: [
                "name": self.txtName.text!,
                "address": self.txtAddress.text!,
                "email": email,
                "role": "user",
                "createdOn": Date()
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID")
                    self.performSegue(withIdentifier: "signUpToTemp", sender: self)
                }
            }
            
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
