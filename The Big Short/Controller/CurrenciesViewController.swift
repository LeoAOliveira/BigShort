//
//  CurrenciesViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 22/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit

class CurrenciesViewController: UIViewController {

    var data1: [Wallet] = []
    var data4: [Currency] = []
    
    var dataManager: DataManager?
    var tableViewDataSource: CurrenciesTableViewDataSource?
    var tableviewDelegate: CurrenciesTableViewDelegate?
    
    var currencyIndex: [Int] = []
    var currencyList = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableviewDelegate = CurrenciesTableViewDelegate(viewController: self)
        tableViewDataSource = CurrenciesTableViewDataSource(viewController: self)
        
        tableView.delegate = tableviewDelegate
        tableView.dataSource = tableViewDataSource
        
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
    
}
