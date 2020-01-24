//
//  MainViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 20/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    public var data1: [Wallet] = []
    public var data2: [Stock] = []
    public var data4: [Currency] = []
    var context: NSManagedObjectContext?
    
    var dataManager: DataManager?
    var tableviewDelegate: MainTableViewDelegate?
    var tableViewDataSource: MainTableViewDataSource?
    
    var stockIndex: [Int] = []
    var stockList = [String]()
    
    var currencyIndex: [Int] = []
    var currencyList = [String]()
    
    var infoSource: String = " "
    var infoUpdate: String = " "
    
    var removeNotifications = UNUserNotificationCenter.current()
    
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableviewDelegate = MainTableViewDelegate(viewController: self)
        tableViewDataSource = MainTableViewDataSource(viewController: self)
        
        tableView.delegate = tableviewDelegate
        tableView.dataSource = tableViewDataSource
        
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.0438792631, green: 0.1104110107, blue: 0.1780112088, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchData()
        
        if data1[0].notifications == true{
            NotificationsManager.setNotifications(notiifcations: removeNotifications, data: data1)
        } else{
            removeNotifications.removeAllPendingNotificationRequests()
        }
    }
    
    // MARK: - Fetch from CoreData and Stock Data update
    
    func fetchData() {
       
        dataManager = DataManager(mainViewController: self)
        
        dataManager?.fetchData(completion: { isValid in
            
            if isValid == true{
                print("Fetched")
                
            } else{
                
                self.createAlert(title: "Erro", message: "Não foi possível atualizar os dados. Por favor, tente novamente mais tarde.", actionTitle: "OK")
            }
        })
        
    }
    
    // MARK: - Create alert
    
    func createAlert(title: String, message: String, actionTitle: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let fillLabelAction = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(fillLabelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Math Functions
    
    func stocksCurrentPrice() -> Float{
        return MathOperations.stocksCurrentPrice(stockList: stockList, data: data2, index: stockIndex)
    }
    
    func stocksPriceClose() -> Float{
        return MathOperations.stocksPriceClose(stockList: stockList, data: data2, index: stockIndex)
    }

    func investedValue() -> Float{
        return MathOperations.investedValue(stockList: stockList, data: data2, index: stockIndex)
    }
    
    // MARK: - Navigation
    
    @IBAction func addStockBtnPressed(_ sender: Any) {
        // verifyMarket(purpose: "buyAndSell")
        performSegue(withIdentifier: "addStockSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "stocksSegue"{
            let destination = segue.destination as! StocksViewController
            
            destination.data1 = self.data1
            destination.data2 = self.data2
            destination.index = self.stockIndex
            destination.stockList = self.stockList
            destination.infoSource = self.infoSource
            destination.infoUpdate = self.infoUpdate
        }
    }
}
