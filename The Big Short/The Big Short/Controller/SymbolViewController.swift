//
//  SymbolViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 31/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData

class SymbolViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var data1: [Wallet] = []
    public var data2: [Stock] = []
    var context: NSManagedObjectContext?
    
    var category: String!
    
    var index = -1
    var selectedStock = " "
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navBarTitle.title = selectedStock
        fetchData()
    }
    
    // MARK: - Fetch from CoreData and Stock Data update
    
    func fetchData(){
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        data2.removeAll()
        
        do{
            data1 = try context!.fetch(Wallet.fetchRequest())
            data2 = try context!.fetch(Stock.fetchRequest())
            
        } catch{
            print(error.localizedDescription)
        }
        
        nameLabel.text = data2[index].name
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Position Card
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "positionCell", for: indexPath) as! PositionCell
            
            cell.positionView.layer.cornerRadius = 10.0
            
            cell.titleLabel.text = "Posição"
            
            cell.totalValueLabel.text = numberFormatter(value: positionPrice())
            cell.investedValueLabel.text = "Valor investido: \(numberFormatter(value: data2[index].invested))"
            
            let change = calculateIncome(value1: data2[index].invested, value2: positionPrice())
            
            if change > 0.0{
                cell.incomeValueLabel.textColor = #colorLiteral(red: 0, green: 0.7020406723, blue: 0.1667427123, alpha: 1)
                cell.incomeValueLabel.text = "+\(numberFormatter(value: calculateIncome(value1: positionPrice(), value2: data2[index].invested)))"
                
            } else if change < 0.0{
                cell.incomeValueLabel.textColor = #colorLiteral(red: 0.7722620368, green: 0.0615144521, blue: 0.1260437667, alpha: 1)
                cell.incomeValueLabel.text = "\(numberFormatter(value: calculateIncome(value1: positionPrice(), value2: data2[index].invested)))"
                
            } else{
                cell.incomeValueLabel.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
                cell.incomeValueLabel.text = "\(numberFormatter(value: calculateIncome(value1: positionPrice(), value2: data2[index].invested)))"
            }
            
            return cell
            
            
        // Today
        } else if indexPath.row == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! TodayCell
            
            cell.todayView.layer.cornerRadius = 10.0
            cell.titleLabel.text = "Hoje (\(formatDate()))"
            cell.changeLabel.text = numberFormatter(value: positionPrice())
            
            let change = calculateChange(value1: stocksPriceClose(), value2: positionPrice())
            
            if change > 0.0{
                cell.changeLabel.textColor = #colorLiteral(red: 0, green: 0.7020406723, blue: 0.1667427123, alpha: 1)
                cell.changeLabel.text = "+\(String(format: "%.2f", change))%"
                
            } else if change < 0.0{
                cell.changeLabel.textColor = #colorLiteral(red: 0.7722620368, green: 0.0615144521, blue: 0.1260437667, alpha: 1)
                cell.changeLabel.text = "\(String(format: "%.2f", change))%"
                
            } else{
                cell.changeLabel.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
                cell.changeLabel.text = "\(String(format: "%.2f", change))%"
            }
            
            
            cell.priceLable.text = numberFormatter(value: data2[index].price)
            
            return cell
            
        // Hist
        } else if indexPath.row == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "histCell", for: indexPath) as! HistoricCell
            
            cell.histView.layer.cornerRadius = 10.0
            cell.mediumPriceLabel.text = numberFormatter(value: data2[index].mediumPrice)
            cell.amountLabel.text = "\(Int(data2[index].amount))"
            
            let change = calculateChange(value1: data2[index].invested, value2: positionPrice())
            
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
            cell.numberLabel.text = ""
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.row == 0{
            return 200
        
        } else{
           return 160
        }
    }
    
    // MARK: - Math Functions
    
    func numberFormatter(value: Float) -> String{
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "pt_BR")
        
        let valueString = currencyFormatter.string(from: NSNumber(value: value))
        
        return valueString!
    }
    
    func calculateChange(value1: Float, value2: Float) -> Float{
        
        let change: Float = ((value2 - value1) / value1) * 100.0
        
        return change
    }
    
    func calculateIncome(value1: Float, value2: Float) -> Float{
        
        let income: Float = value1 - value2
        
        return income
    }
    
    func formatDate() -> String{
        
        let lastUpdate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        dateFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        
        return dateFormatter.string(from: lastUpdate)
    }
    
    func positionPrice() -> Float{
        
        let position: Float = data2[index].price * data2[index].amount
        
        return position
    }
    
    func stocksPriceClose() -> Float{
        
        let close = data2[index].close * data2[index].amount
        
        return close
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "directSegue"{
//            
//            selectedStock = 
//            
//            let destination = segue.destination as! BuySellStockViewController
//            destination.selectedStock = selectedStock
//            
//        }
//    }

}
