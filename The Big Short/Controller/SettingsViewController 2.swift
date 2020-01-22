//
//  SettingsViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 04/08/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Notification Card
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsCell", for: indexPath) as! NotificationCell
            
            
            
            cell.notificationView.layer.cornerRadius = 10.0
            
            return cell
            
            
        // User Terms
        } else if indexPath.row == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "useLicenseCell", for: indexPath) as! WordCell
            
            cell.wordView.layer.cornerRadius = 10.0
            
            return cell
            
        // Tutorial
        } else if indexPath.row == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "tutorialCell", for: indexPath) as! WordCell
            
            cell.wordView.layer.cornerRadius = 10.0
            
            return cell
            
            
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "tutorialCell", for: indexPath) as! WordCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            
            return 170
            
        } else{
            
            return 80
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
