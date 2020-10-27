//
//  InvestmentViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 26/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import Foundation
import UIKit

class StocksViewController: UIViewController {
    
    var data1: [Wallet] = []
    var data2: [Stock] = []
    
    var dataManager: DataManager?
    var tableViewDataSource: StocksTableViewDataSource?
    var tableviewDelegate: StocksTableViewDelegate?
    
    var index: [Int] = []
    var stockList = [String]()
    var selectedIndex = -1
    var selectedStock = " "
    
    var marketLabel: String = " "
    var marketColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.0438792631, green: 0.1104110107, blue: 0.1780112088, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        verifyMarket(purpose: "keepTracking")
        fetchData()
    }
    
    // MARK: - Set TableView
    
    func setupTableView() {
        
        tableviewDelegate = StocksTableViewDelegate(viewController: self)
        tableViewDataSource = StocksTableViewDataSource(viewController: self)
        
        tableView.delegate = self.tableviewDelegate
        tableView.dataSource = self.tableViewDataSource
    }
    
    // MARK: - Fetch from CoreData and Stock Data update
    
    func fetchData() {
       
        dataManager = DataManager(stocksViewController: self)
        
        dataManager?.fetchData(completion: { isValid in
            
            if isValid == true {
                self.tableView.reloadData()
                
            } else {
                self.createAlert(title: "Erro", message: "Não foi possível atualizar os dados. Por favor, tente novamente mais tarde.", actionTitle: "OK")
            }
        })
    }
    
    // MARK: - Market verification
    
    func verifyMarket(purpose: String){
        
        let marketStatus = MarketManager.verifyMarket(purpose: purpose)
        
        if marketStatus == "Market closed" {
            marketColor = #colorLiteral(red: 0.1047265753, green: 0.2495177984, blue: 0.4248503447, alpha: 1)
            marketLabel = "Mercado fechado"
            
        } else if marketStatus == "Market closed alert" {
            createAlert(title: "Mercado fechado", message: "Operações só podem ser realizadas das 10:00 às 17:00", actionTitle: "OK")
            
        } else if marketStatus == "Market closed alert 2" {
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
    
    // MARK: - Create alert
    
    func createAlert(title: String, message: String, actionTitle: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let fillLabelAction = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(fillLabelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    @IBAction func addStockBtnPressed(_ sender: Any) {
         verifyMarket(purpose: "buyAndSell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "detailStockSegue"{
            let destination = segue.destination as! SymbolViewController
            destination.index = selectedIndex
            destination.selectedStock = selectedStock
            destination.data1 = data1
            destination.data2 = data2
        }
        
        if segue.identifier == "walletStockSegue"{
            let destination = segue.destination as! WalletViewController
            destination.segmentedIndex = 1
        }
    }
}
