
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
    
    var balanceTextField: UITextField?

    @IBOutlet weak var notificationsSwitch: UISwitch!
    var removeNotifications = UNUserNotificationCenter.current()
    
    public var data1: [Wallet] = []
    public var data2: [Stock] = []
    public var data4: [Currency] = []
    var context: NSManagedObjectContext?
    
    var wantsNotifications: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.0438792631, green: 0.1104110107, blue: 0.1780112088, alpha: 1)
        
        notificationsView.layer.cornerRadius = 10.0
        userTermsView.layer.cornerRadius = 10.0
        tutorialView.layer.cornerRadius = 10.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        notificationsSwitch.isOn = data1[0].notifications
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
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3{
            
            let alert = UIAlertController(title: "Adicionar saldo", message: "Entre o valor que deseja adicionar ao saldo disponível. Máximo: 10.000.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addTextField(configurationHandler: balanceTextField)
            
            let action1 = UIAlertAction(title: "Confirmar", style: UIAlertAction.Style.default, handler: addHandle)
            alert.addAction(action1)
            
            let action2 = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive, handler: nil)
            alert.addAction(action2)
            
            self.present(alert, animated: true, completion: nil)
        
        } else if indexPath.row == 4{
            
            let alert = UIAlertController(title: "Reiniciar simulador", message: "Essa ação irá deletar todo o progresso atual. Tem certeza que quer prosseguir?", preferredStyle: UIAlertController.Style.alert)
            
            let action1 = UIAlertAction(title: "Confirmar", style: UIAlertAction.Style.default, handler: restartHandler)
            
            alert.addAction(action1)
            
            let action2 = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive, handler: nil)
            alert.addAction(action2)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func balanceTextField(textField: UITextField){
        balanceTextField = textField
        balanceTextField?.placeholder = "Escreva aqui"
        balanceTextField?.keyboardType = UIKeyboardType.numberPad
        balanceTextField?.keyboardAppearance = UIKeyboardAppearance.dark
    }
    
    func addHandle(alert: UIAlertAction!){
        
        if balanceTextField!.text != nil && balanceTextField!.text != ""{
            
            let balance: Float = Float(balanceTextField!.text!)!
            
            if balance <= 10000{
                
                context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                do{
                    data1[0].availableBalance += Float(balanceTextField!.text!)!
                    try self.context?.save()
                    
                } catch{
                    print("Error when saving context")
                }
            
            }
        }
    }
    
    func restartHandler(alert: UIAlertAction){
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        data1.removeAll()
        
        do {
            
            data1 = try context!.fetch(Wallet.fetchRequest())
            data2 = try context!.fetch(Stock.fetchRequest())
            data4 = try context!.fetch(Currency.fetchRequest())
            
            data1[0].stock1 = nil
            data1[0].stock2 = nil
            data1[0].stock3 = nil
            data1[0].stock4 = nil
            data1[0].stock5 = nil
            data1[0].availableBalance = 0.0
            data1[0].stocksValue = 0.0
            data1[0].totalValue = 0.0
            data1[0].currencyList = ""
            data1[0].stockList = ""
            
            for i in 0...72{
                data2[i].income = 0.0
                data2[i].invested = 0.0
                data2[i].amount = 0.0
                data2[i].changePercentage = ""
                data2[i].price = 0.0
                data2[i].mediumPrice = 0.0
                data2[i].timesBought = 0
            }
            
            for i in 0...47{
                data4[i].invested = 0.0
                data4[i].investedBRL = 0.0
                data4[i].timesBought = 0
                data4[i].price = 0.0
                data4[i].mediumPrice = 0.0
            }
            
            do{
                try context!.save()
                
            } catch{
                print("Error when saving context")
            }
            
        } catch {
            print("Erro ao inserir os dados de ações")
            print(error.localizedDescription)
        }
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        performSegue(withIdentifier: "restartSegue", sender: self)
    }
    
    @IBAction func notificationsSwitchChanged(_ sender: Any) {
        
        if notificationsSwitch.isOn{
            data1[0].notifications = true
        
        } else{
            data1[0].notifications = false
        }
    }
    
    
}
