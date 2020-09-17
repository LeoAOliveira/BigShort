//
//  SymbolViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 31/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import Foundation
import UIKit

class SymbolViewController: UIViewController {
    
    var data1: [Wallet] = []
    var data2: [Stock] = []
    
    var dataManager: DataManager?
    var tableViewDataSource: SymbolTableViewDataSource?
    var tableviewDelegate: SymbolTableViewDelegate?
    
    var category: String!
    
    var index = -1
    var selectedStock = " "
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.0438792631, green: 0.1104110107, blue: 0.1780112088, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navBarTitle.title = selectedStock
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 241/255, green: 246/255, blue: 252/255, alpha: 1.0)]
        
        fetchData()
    }
    
    // MARK: - Set TableView
    
    func setupTableView() {
        
        tableviewDelegate = SymbolTableViewDelegate(viewController: self)
        tableViewDataSource = SymbolTableViewDataSource(viewController: self)
        
        tableView.delegate = self.tableviewDelegate
        tableView.dataSource = self.tableViewDataSource
    }
    
    // MARK: - Fetch from CoreData
    
    func fetchData() {
       
        dataManager = DataManager(symbolViewController: self)
        
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
        
        if marketStatus == "Market closed alert" {
            createAlert(title: "Mercado fechado", message: "Operações só podem ser realizadas das 10:00 às 17:00", actionTitle: "OK")
            
        } else if marketStatus == "Market closed alert 2" {
            createAlert(title: "Mercado fechado", message: "Operações só podem ser realizadas em dias úteis.", actionTitle: "OK")
            
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
    
    @IBAction func addBtnPressed(_ sender: Any) {
        verifyMarket(purpose: "buyAndSell")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addThisStockSegue"{
            
            let destination = segue.destination as! BuySellStockViewController
            destination.selectedStock = navBarTitle.title
            destination.data1 = data1
            destination.data2 = data2
            destination.parentVC = self
            tabBarController?.tabBar.isHidden = true
            
        }
    }

}
