//
//  WalletViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 27/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData

class WalletViewController: UIViewController {
    
    public var data1: [Wallet] = []
    public var data2: [Stock] = []
    public var data4: [Currency] = []
    var context: NSManagedObjectContext?
    
    var dataManager: DataManager?
    var tableviewDelegate: WalletTableViewDelegate?
    var tableViewDataSource: WalletTableViewDataSource?
    
    var segmentedIndex = 0
    
    var stockIndex: [Int] = []
    var stockList = [String]()
    
    var currencyIndex: [Int] = []
    var currencyList = [String]()
    
    var infoSource: String = " "
    var infoUpdate: String = " "
    
    var removeNotifications = UNUserNotificationCenter.current()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmented: UISegmentedControl!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.0438792631, green: 0.1104110107, blue: 0.1780112088, alpha: 1)
        
        segmented.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.08235294118, green: 0.1568627451, blue: 0.2941176471, alpha: 1)], for: .selected)
        segmented.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.9647058824, blue: 0.9882352941, alpha: 1)], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        segmented.selectedSegmentIndex = segmentedIndex
        fetchData()
    }
    
    // MARK: - Fetch from CoreData and Stock Data update
    
    func fetchData() {
       
        dataManager = DataManager(walletViewController: self)
        
        dataManager?.fetchData(completion: { isValid in
            
            if isValid == true{
                
                self.tableviewDelegate = WalletTableViewDelegate(viewController: self)
                self.tableViewDataSource = WalletTableViewDataSource(viewController: self)
                
                self.tableView.delegate = self.tableviewDelegate
                self.tableView.dataSource = self.tableViewDataSource
                
            } else{
                
                self.createAlert(title: "Erro", message: "Não foi possível atualizar os dados. Por favor, tente novamente mais tarde.", actionTitle: "OK")
            }
        })
        
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        
        tableView.reloadData()
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

    func investedValue() -> Float{
        return MathOperations.investedValue(stockList: stockList, data: data2, index: stockIndex)
    }
}

