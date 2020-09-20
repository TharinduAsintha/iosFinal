//
//  ProfileViewController.swift
//  WijekoonWHMCB-COBSCCOMP191P-006
//
//  Created by Chathura Wijekoon on 9/19/20.
//  Copyright © 2020 Chathura Wijekoon. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imgProPic: UIImageView!
    @IBOutlet weak var lblUserSince: UILabel!
    
    @IBOutlet weak var lblCurrentTemp: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtUserAddress: UITextField!
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    var documentId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let profileImageViewAction = UITapGestureRecognizer(target: self, action: #selector(imageUIViewAction(_:)))
        imgProPic.isUserInteractionEnabled = true
        imgProPic.addGestureRecognizer(profileImageViewAction)
    }
    
    func loadUser() {
        if let email = Auth.auth().currentUser?.email {
            db.collection("users").whereField("email", isEqualTo: email)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let document = querySnapshot!.documents[0]
                        
                        self.documentId = document.documentID
                        
                        if let name = document.data()["name"] as? String, let address = document.data()["address"] as? String, let userSince = document.data()["createdOn"] as? Timestamp {
                            print(document.data())
                            self.navigationItem.title = name as? String
                            
                            self.txtUserName.text = name
                            self.txtUserAddress.text = address
                            self.lblUserSince.text = "\(userSince.dateValue().getFormattedDate(format: "MMM yyyy"))"
                            
                            let mf = MeasurementFormatter()
                            if let bodyTemp = document.data()["temp"] as? String {
                                let temp = Measurement(value: Double(bodyTemp) ?? 0, unit: UnitTemperature.celsius)
                                mf.locale = Locale(identifier: "en_GB")
                                print(mf.string(from: temp))
                                self.lblCurrentTemp.text = "\(mf.string(from: temp))"
                            }
                            
                        }
                    }
            }
        }
    }
    
    @IBAction func btnProfileUpdate(_ sender: Any) {
        if documentId != "", let name = txtUserName.text, let address = txtUserAddress.text {
            db.collection("users").document(documentId).updateData(["name": name, "address": address]) {error in
                if let err = error {
                    print(err)
                    
                    self.txtUserName.text = ""
                    self.txtUserAddress.text = ""
                    
                    return
                }
            }
        }
        
    }
    
    @objc func imageUIViewAction(_ sender:UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
        if let uid = Auth.auth().currentUser?.uid {
            
            let ref = "images/\(uid).png"
            
            storage.child(ref).putData(imageData, metadata: nil, completion: { _, error in
                if let e = error {
                    print(e)
                }
                self.storage.child(ref).downloadURL { (url, error) in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                    
                    self.db.collection("users").document(self.documentId).updateData(["profileImage": urlString])
                    
                    let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                        guard let data = data, error == nil else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            let image = UIImage(data: data)
                            self.imgProPic.image = image
                        }
                    }
                    
                    task.resume()
                }
            })
        }
    }
}



extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

