//
//  SettingsViewController.swift
//  WijekoonWHMCB-COBSCCOMP191P-006
//
//  Created by Chathura Wijekoon on 9/18/20.
//  Copyright © 2020 Chathura Wijekoon. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var btnLogoutRef: CustomButton!
    
    @IBOutlet weak var tblView: UITableView!
    
    var settingCells = [
        "Profile",
        "Contact Us",
        "Share with Friend",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        if Auth.auth().currentUser == nil{
            btnLogoutRef.isHidden = true
        }
        
    }
    
    @IBAction func btnClose(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    
    @IBAction func btnLogout(_ sender: Any) {
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            tabBarController?.selectedIndex = 0
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }
}

extension SettingsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        if indexPath.row == 0 {
            performSegue(withIdentifier: "settingsToProfile", sender: self)
        }
        else if indexPath.row == 1 {
            performSegue(withIdentifier: "settingsToContactUs", sender: self)
        }
    }
}

extension SettingsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        cell.textLabel?.text = settingCells[indexPath.row]
        return cell
    }
}
