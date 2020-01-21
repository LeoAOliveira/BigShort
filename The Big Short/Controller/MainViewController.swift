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
    var context: NSManagedObjectContext?
    
    var stockDataManager: StockDataManager?
    var tableviewDelegate: MainTableViewDelegate?
    var tableViewDataSource: MainTableViewDataSource?
    
    var category: String!
    
    var index: [Int] = []
    var stockList = [String]()
    var selectedIndex = -1
    var selectedStock = " "
    
    var infoSource: String = " "
    var infoUpdate: String = " "
    
    var marketLabel: String = " "
    var marketColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    var hasYDUQ3: Bool = false
    
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
        
        verifyMarket(purpose: "keepTracking")
        fetchData()
        
        if data1[0].notifications == true{
            NotificationsManager.setNotifications(notiifcations: removeNotifications, data: data1)
        } else{
            removeNotifications.removeAllPendingNotificationRequests()
        }
    }
    
    // MARK: - Fetch from CoreData and Stock Data update
    
    func fetchData() {
       
        self.stockDataManager = StockDataManager(viewController: self)
        stockDataManager?.fetchData(completion: { isValid in
            
            if isValid == true{
                print("YESS")
                
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
        return MathOperations.stocksCurrentPrice(stockList: stockList, data: data2, index: index)
    }
    
    func stocksPriceClose() -> Float{
        return MathOperations.stocksPriceClose(stockList: stockList, data: data2, index: index)
    }

    func investedValue() -> Float{
        return MathOperations.investedValue(stockList: stockList, data: data2, index: index)
    }
    
    // MARK: - Market verification
    func verifyMarket(purpose: String){
        
        let marketStatus = MarketManager.verifyMarket(purpose: purpose)
        
        if marketStatus == "Market closed" {
            marketColor = #colorLiteral(red: 0.1047265753, green: 0.2495177984, blue: 0.4248503447, alpha: 1)
            marketLabel = "Mercado fechado"
            
        } else if marketStatus == "Market closed alert" {
            createAlert(title: "Mercado fechado", message: "Operações só podem ser realizadas em dias úteis.", actionTitle: "OK")
            
        } else if marketStatus == "Market open" {
            marketColor = #colorLiteral(red: 0.4889312983, green: 0.7110515833, blue: 1, alpha: 1)
            marketLabel = "Mercado aberto"
            
        } else if marketStatus == "Operations avilable" {
            performSegue(withIdentifier: "addStockSegue", sender: self)
            
        } else {
            print("Error at market verification")
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func addStockBtnPressed(_ sender: Any) {
        // verifyMarket(purpose: "buyAndSell")
        performSegue(withIdentifier: "addStockSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "detailStockSegue"{
            let destination = segue.destination as! SymbolViewController
            destination.index = selectedIndex
            destination.selectedStock = selectedStock
        }
    }
}
