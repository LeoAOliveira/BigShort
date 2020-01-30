//
//  CodeViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 30/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CodeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var data1: [Wallet] = []
    public var data4: [Currency] = []
    var context: NSManagedObjectContext?
    
    var category: String!
    
    var index = -1
    var selectedCurrency = " "
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.0438792631, green: 0.1104110107, blue: 0.1780112088, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navBarTitle.title = selectedCurrency
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 241/255, green: 246/255, blue: 252/255, alpha: 1.0)]
        fetchData()
    }
    
    // MARK: - Fetch from CoreData and Stock Data update
    
    func sortCurrencies() {
        let sortedData4 = self.data4.sorted(by: { $0.symbol! < $1.symbol! })
        data4 = sortedData4
        
        do {
            try self.context?.save()
            
        } catch{
            print("Error when sorting")
        }
    }
    
    func fetchData(){
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        data1.removeAll()
        data4.removeAll()
        
        do {
            data1 = try context!.fetch(Wallet.fetchRequest())
            data4 = try context!.fetch(Currency.fetchRequest())
            
        } catch {
            print(error.localizedDescription)
        }
        
        sortCurrencies()
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let symbol = data4[index].symbol else {
            return UITableViewCell()
        }
        
        guard let name = data4[index].name else {
            return UITableViewCell()
        }
        
        let invested = Float(data4[index].invested)
        let investedBRL = Float(data4[index].investedBRL)
        let price = Float(data4[index].price)
        let mediumValue = Float(data4[index].mediumPrice)
        
        let value = MathOperations.currencyFormatter(value: Float(invested*price))
        let priceCurrency = MathOperations.currencyFormatter(value: Float(price))
        let mediumPrice = MathOperations.currencyFormatter(value: Float(mediumValue))
        let change = MathOperations.calculateChange(value1: investedBRL, value2: invested*price)
        
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "positionCell", for: indexPath) as! InvestmentsCell
            
            cell.titleLabel.text = "Posição"
            
            cell.valueLabel.text = value
            cell.valueLabel.text = value
            cell.currencyValueLabel.text = "\(symbol) \(String(format: "%.2f", invested))"
            
            let incomeValue = Double(MathOperations.calculateIncome(value1: invested*price, value2: investedBRL))
            
            if incomeValue > 0 {
                cell.descriptionLabel.text = "+ \(MathOperations.currencyFormatter(value: Float(incomeValue)))"
                cell.descriptionLabel.textColor = #colorLiteral(red: 0.1176470588, green: 0.6901960784, blue: 0.2549019608, alpha: 1)
            
            } else if incomeValue < 0 {
                cell.descriptionLabel.text = "- \(MathOperations.currencyFormatter(value: Float(incomeValue) * -1.0))"
                cell.descriptionLabel.textColor = #colorLiteral(red: 0.7098039216, green: 0.1647058824, blue: 0.1647058824, alpha: 1)
            
            } else{
                cell.descriptionLabel.text = MathOperations.currencyFormatter(value: Float(incomeValue))
                cell.descriptionLabel.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
            }
            
            return cell
        
        // Country Card
        } else if indexPath.row == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! SimpleCell
            
            cell.simpleView.layer.cornerRadius = 10.0
            
            cell.titleLabel.text = name
            cell.descriptionLabel.text = data4[index].region!
            cell.imageLogo.image = UIImage(named: "\(data4[index].symbol!).png")
            
            return cell
            
            
        // Today
        } else if indexPath.row == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! TodayCell
            
            cell.todayView.layer.cornerRadius = 10.0
            cell.todaySubView.layer.cornerRadius = 10.0
            cell.titleLabel.text = "Hoje (\(formatDate()))"
            
            cell.priceLable.text = priceCurrency
            
            return cell
            
        // Hist
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "histCell", for: indexPath) as! HistoricCell
            
            cell.histView.layer.cornerRadius = 10.0
            cell.histSubView.layer.cornerRadius = 10.0
            cell.mediumPriceLabel.text = mediumPrice
            
            if change > 0.0{
                cell.totalChangeLabel.textColor = #colorLiteral(red: 0, green: 0.7020406723, blue: 0.1667427123, alpha: 1)
                cell.totalChangeLabel.text = "+\(String(format: "%.2f", change))%"
                
            } else if change < 0.0{
                cell.totalChangeLabel.textColor = #colorLiteral(red: 0.7722620368, green: 0.0615144521, blue: 0.1260437667, alpha: 1)
                cell.totalChangeLabel.text = "\(String(format: "%.2f", change))%"
                
            } else{
                cell.totalChangeLabel.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
                cell.totalChangeLabel.text = "\(String(format: "%.2f", change))%"
            }
            
            return cell
            
            
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "investmentsCell", for: indexPath) as! InvestmentsCell
            
            cell.titleLabel.text = ""
            cell.valueLabel.text = ""
            cell.descriptionLabel.text = ""
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.row == 0 {
            return 170
        
        } else if indexPath.row == 1 {
            return 110
        
        } else if indexPath.row == 2 {
           return 160
            
        } else if indexPath.row == 3 {
           return 160
            
        } else{
            return 190
        }
    }
    
    // MARK: - Math Functions
    
    func formatDate() -> String{
        
        let lastUpdate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        dateFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        
        return dateFormatter.string(from: lastUpdate)
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
