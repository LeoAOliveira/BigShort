//
//  CodeViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 30/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import Foundation
import UIKit

class CodeViewController: UIViewController {
    
    var data1: [Wallet] = []
    var data4: [Currency] = []
    
    var dataManager: DataManager?
    var tableViewDataSource: CodeTableViewDataSource?
    var tableviewDelegate: CodeTableViewDelegate?
    
    var category: String!
    
    var index = -1
    var selectedCurrency = " "
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.0438792631, green: 0.1104110107, blue: 0.1780112088, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navBarTitle.title = selectedCurrency
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 241/255, green: 246/255, blue: 252/255, alpha: 1.0)]
        
        fetchData()
    }
    
    // MARK: - Set TableView
    
    func setupTableView() {
        
        tableviewDelegate = CodeTableViewDelegate(viewController: self)
        tableViewDataSource = CodeTableViewDataSource(viewController: self)
        
        tableView.delegate = self.tableviewDelegate
        tableView.dataSource = self.tableViewDataSource
    }
    
    // MARK: - Fetch from CoreData
    
    func fetchData() {
        
        dataManager = DataManager(codeViewController: self)
        
        dataManager?.fetchData(completion: { isValid in
            
            if isValid == true {
                self.tableView.reloadData()
                
            } else {
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
        
        if segue.identifier == "addThisCurrencySegue"{
            
            let destination = segue.destination as! BuySellCurrencyViewController
            destination.selectedCurrency = navBarTitle.title
            destination.data1 = data1
            destination.data4 = data4
            destination.parentVC = self
            tabBarController?.tabBar.isHidden = true
            
        }
    }

}
