//
//  SignInViewController.swift
//  WijekoonWHMCB-COBSCCOMP191P-006
//
//  Created by Chathura Wijekoon on 9/18/20.
//  Copyright © 2020 Chathura Wijekoon. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClose(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let err = error {
                print(err)
                return
            }
            self.performSegue(withIdentifier: "signInToTemp", sender: self)
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
