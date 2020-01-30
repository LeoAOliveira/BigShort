//
//  CurrenciesViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 22/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import Foundation

class CurrenciesViewController: UIViewController {

    var data1: [Wallet] = []
    var data4: [Currency] = []
    
    var dataManager: DataManager?
    var tableViewDataSource: CurrenciesTableViewDataSource?
    var tableviewDelegate: CurrenciesTableViewDelegate?
    
    var currencyIndex: [Int] = []
    var currencyList: [String] = [String]()
    var selectedIndex = -1
    var selectedCurrency = " "
    
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.0438792631, green: 0.1104110107, blue: 0.1780112088, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    // MARK: - Fetch from CoreData and Stock Data update
    
    func fetchData() {
       
        dataManager = DataManager(currenciesViewController: self)
        
        dataManager?.fetchData(completion: { isValid in
            
            if isValid == true{
                
                self.tableviewDelegate = CurrenciesTableViewDelegate(viewController: self)
                self.tableViewDataSource = CurrenciesTableViewDataSource(viewController: self)
                
                self.tableView.delegate = self.tableviewDelegate
                self.tableView.dataSource = self.tableViewDataSource
                
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailCurrencySegue"{
            let destination = segue.destination as! CodeViewController
            destination.index = selectedIndex
            destination.selectedCurrency = selectedCurrency
            destination.data1 = data1
            destination.data4 = data4
        }

        if segue.identifier == "walletCurrencySegue"{
            let destination = segue.destination as! WalletViewController
            destination.segmentedIndex = 2
        }
    }
    
}
