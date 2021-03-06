
//
//  SettingsTableViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 04/08/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class SettingsTableViewController: UITableViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var notificationsView: UIView!
    @IBOutlet weak var userTermsView: UIView!
    @IBOutlet weak var tutorialView: UIView!
    

    @IBOutlet weak var notificationsSwitch: UISwitch!
    var removeNotifications = UNUserNotificationCenter.current()
    
    public var data1: [Wallet] = []
    var context: NSManagedObjectContext?
    
    var wantsNotifications: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsView.layer.cornerRadius = 10.0
        userTermsView.layer.cornerRadius = 10.0
        tutorialView.layer.cornerRadius = 10.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            
            try self.context?.save()
            
            if data1[0].notifications == true{
                notifications()
            }
            
        } catch{
            print("Error when saving context")
        }
    }
    
    func fetchData(){
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        data1.removeAll()
        
        do{
            data1 = try context!.fetch(Wallet.fetchRequest())
            
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func notifications(){
        
        removeNotifications.removeAllPendingNotificationRequests()
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                // Abertura
                let content1 = UNMutableNotificationContent()
                content1.title = NSString.localizedUserNotificationString(forKey: "Mercado aberto", arguments: nil)
                content1.sound = UNNotificationSound.default
                
                var dateConponents1 = DateComponents()
                dateConponents1.hour = 10
                dateConponents1.minute = 00
                
                
                let trigger1 = UNCalendarNotificationTrigger(dateMatching: dateConponents1, repeats: false)
                
                let request1 = UNNotificationRequest(identifier: "market1", content: content1, trigger: trigger1)
                
                let center1 = UNUserNotificationCenter.current()
                center1.add(request1) { (error : Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
                // Fechamento
                let content2 = UNMutableNotificationContent()
                content2.title = NSString.localizedUserNotificationString(forKey: "Mercado fechado", arguments: nil)
                content2.sound = UNNotificationSound.default
                
                var dateConponents2 = DateComponents()
                dateConponents2.hour = 17
                dateConponents2.minute = 00
                
                
                let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateConponents2, repeats: false)
                
                let request2 = UNNotificationRequest(identifier: "market2", content: content2, trigger: trigger2)
                
                let center2 = UNUserNotificationCenter.current()
                center2.add(request2) { (error : Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            } else {
                print("Impossível mandar notificação - permissão negada")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    @IBAction func notificationsSwitchChanged(_ sender: Any) {
        
        if notificationsSwitch.isOn{
            data1[0].notifications = true
        
        } else{
            data1[0].notifications = false
        }
    }
    
    
}
