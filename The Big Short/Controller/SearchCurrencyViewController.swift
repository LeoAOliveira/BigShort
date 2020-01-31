//
//  SearchCurrencyViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 22/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class SearchCurrencyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var data1: [Wallet] = []
    var data4: [Currency] = []
    var context: NSManagedObjectContext?
    
    var selectedCurrency = " "
    
    var currencyArray = [Currency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.0438792631, green: 0.1104110107, blue: 0.1780112088, alpha: 1)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        fetchData()
    }
    
    // MARK: - Fetch from CoreData
    
    func fetchData(){
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            data1 = try context!.fetch(Wallet.fetchRequest())
            data4 = try context!.fetch(Currency.fetchRequest())
            
            currencyArray = data4
            
        } catch{
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as? SimpleCell else{
            return UITableViewCell()
        }
        
        cell.titleLabel.text = currencyArray[indexPath.row].symbol
        cell.descriptionLabel.text = currencyArray[indexPath.row].name
        cell.imageLogo.image = UIImage(named: "\(currencyArray[indexPath.row].symbol!).pdf")
        cell.simpleView.layer.cornerRadius = 10.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    // MARK: - Search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            currencyArray = data4
            tableView.reloadData()
            return
        }
        
        currencyArray = data4.filter({ currency -> Bool in
            currency.country!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectCurrencySegue"{
            
            selectedCurrency = (sender as! SimpleCell).titleLabel.text!
            
            let destination = segue.destination as! BuySellCurrencyViewController
            destination.data1 = data1
            destination.data4 = data4
            destination.selectedCurrency = selectedCurrency
            destination.parentVC = self
            tabBarController?.tabBar.isHidden = true
            
        }
    }
}
