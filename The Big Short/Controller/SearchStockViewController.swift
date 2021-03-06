//
//  SearchStockViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 29/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class SearchStockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    public var data1: [Wallet] = []
    public var data2: [Stock] = []
    var context: NSManagedObjectContext?
    
    var selectedStock = " "
    
    var stockArray = [Stock]()
    
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
        sortStocks()
    }
    
    // MARK: - Sort Data
    
    func sortStocks() {
        
        let sortedData2 = self.data2.sorted(by: { $0.symbol! < $1.symbol! })
        data2 = sortedData2
        stockArray = data2
        
        do {
            try self.context?.save()
            
        } catch{
            print("Error when sorting")
        }
    }
    
    // MARK: - Fetch from CoreData
    
    func fetchData() {
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            data1 = try context!.fetch(Wallet.fetchRequest())
            data2 = try context!.fetch(Stock.fetchRequest())
            
        } catch{
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as? SimpleCell else{
            return UITableViewCell()
        }
        
        cell.titleLabel.text = stockArray[indexPath.row].symbol
        cell.descriptionLabel.text = stockArray[indexPath.row].name
        cell.footLabel.text = "Setor: \(stockArray[indexPath.row].sector!)"
        cell.imageLogo.image = UIImage(named: "\(stockArray[indexPath.row].imageName!).pdf")
        cell.simpleView.layer.cornerRadius = 10.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    // MARK: - Search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            stockArray = data2
            tableView.reloadData()
            return
        }
        
        stockArray = data2.filter({ stock -> Bool in
            stock.name!.lowercased().contains(searchText.lowercased()) || 
                stock.symbol!.lowercased().contains(searchText.lowercased()) || 
                stock.sector!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectStocksSegue"{
            
            selectedStock = (sender as! SimpleCell).titleLabel.text!
            
            let destination = segue.destination as! BuySellStockViewController
            destination.selectedStock = selectedStock
            destination.data1 = data1
            destination.data2 = data2
            destination.parentVC = self
            tabBarController?.tabBar.isHidden = true
            
        }
    }
    
}
