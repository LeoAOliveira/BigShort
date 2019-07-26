//
//  SimulatorViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 25/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData

class SimulatorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    public var data1: [Wallet] = []
    public var data2: [Stock] = []
    var context: NSManagedObjectContext?
    
    var index: [Int] = []
    var stockList = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        fetchData()
    }
    
    // MARK: - Fetch from CoreData and Stock Data update
    
    func fetchData(){
        
        do{
            data1 = try context!.fetch(Wallet.fetchRequest())
            
        } catch{
            print(error.localizedDescription)
        }
        
        // Verify how many stocks the user has
        
        if data1[0].stock1 != nil{
            stockList.append(data1[0].stock1!)
        }
        
        if data1[0].stock2 != nil{
            stockList.append(data1[0].stock2!)
        }
        
        if data1[0].stock3 != nil{
            stockList.append(data1[0].stock3!)
        }
        
        if data1[0].stock4 != nil{
            stockList.append(data1[0].stock4!)
        }
        
        if data1[0].stock5 != nil{
            stockList.append(data1[0].stock5!)
        }
        
        // Get selected stock data
        
        if stockList.count >= 1{
            
            do{
                
                for i in 0...stockList.count-1{
                    
                    data2 = try context!.fetch(Stock.fetchRequest())
                    
                    for n in 0...65{
                        
                        if data2[n].symbol == stockList[i]{
                            index.append(n)
                        }
                    }
                }
                
                verifyUpdate(lastUpdate: data1[0].lastUpdate!)
                tableView.reloadData()
                
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func verifyUpdate(lastUpdate: String){
        
        // Current date and last update
        
        let dateCurrent = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString = dateFormatter.string(from: dateCurrent)
        
        let lastUpdateDate = dateFormatter.date(from: lastUpdate)!
        let nowDate = dateFormatter.date(from: dateString)!
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        
        // Reference dates
        
        let openTimeString = "\(dayFormatter.string(from: dateCurrent)) 10:00"
        let openTime = dateFormatter.date(from: openTimeString)!
        
        let closeTimeString = "\(dayFormatter.string(from: dateCurrent)) 17:00"
        let closeTime = dateFormatter.date(from: closeTimeString)!
        
        let midnightOpenString = "\(dayFormatter.string(from: dateCurrent)) 00:00"
        let midnightOpen = dateFormatter.date(from: midnightOpenString)!
        
        let midnightCloseString = "\(dayFormatter.string(from: dateCurrent)) 23:59"
        let midnightClose = dateFormatter.date(from: midnightCloseString)!
        
        // Verification
        
        if nowDate < openTime{
            
            if lastUpdateDate < midnightOpen{
                updateStockData()
            }
            
        } else if nowDate > closeTime {
            
            if lastUpdateDate < midnightClose && lastUpdateDate > closeTime{
                updateStockData()
            }
            
        } else{
            
            let difference = nowDate.timeIntervalSince(closeTime)
            let differenceInHours = floor(difference / 60 / 60)
            
            if differenceInHours > 1{
                updateStockData()
            }
            
        }
    }
    
    func updateStockData(){
        
        if stockList.count > 2{
            MultiStockData(stocksSelection: stockList)
        } else{
            StockData(stocksSelection: stockList)
        }
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Wallet Card
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath) as! WalletCell
            
            cell.titleLabel.text = "Carteira"
            cell.totalValueLabel.text = "\(numberFormatter(value: data1[0].totalValue))"
            cell.availableBalanceLabel.text = "Saldo disponível: \(numberFormatter(value: data1[0].availableBalance))"
            
            cell.stocksPercentageLabel.text = "\(calculatePercentage(value: data1[0].stocksValue))%"
            cell.stocksLabel.text = "Ações"
            
            cell.publicTitlesPercentageLabel.text = "\(calculatePercentage(value: data1[0].publicTitlesValue))%"
            cell.publicTitlesLabel.text = "Títulos públicos"
            
            cell.dollarPercentageLabel.text = "\(calculatePercentage(value: data1[0].dollarValue))%"
            cell.dollarLabel.text = "Dólar (USD)"
            
            cell.savingsPercentageLabel.text = "\(calculatePercentage(value: data1[0].savingsValue))%"
            cell.savingsLabel.text = "Poupança"
            
            return cell
            
            
        // Stocks Card
        } else if indexPath.row == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "investmentsCell", for: indexPath) as! InvestmentsCell
            
            cell.titleLabel.text = "Ações"
            cell.valueLabel.text = "\(numberFormatter(value: data1[0].stocksValue))"
            cell.descriptionLabel.text = "Variação do dia: "
            cell.numberLabel.text = "\(calculateChange(value1: stocksPriceOpen(), value2: data1[0].stocksValue))%"
            
            return cell
            
            
        // Public Titles Card
        } else if indexPath.row == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "investmentsCell", for: indexPath) as! InvestmentsCell
            
            let test = 123
            
            cell.titleLabel.text = "Títulos públicos"
            cell.valueLabel.text = "\(numberFormatter(value: data1[0].publicTitlesValue))"
            cell.descriptionLabel.text = "Variação do dia: "
            cell.numberLabel.text = "\(test)%"
            
            return cell
            
        // Dollar Card
        }else if indexPath.row == 3{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "investmentsCell", for: indexPath) as! InvestmentsCell
            
            let test = 123
            
            cell.titleLabel.text = "Dólar americano (USD)"
            cell.valueLabel.text = "\(numberFormatter(value: data1[0].dollarValue))"
            cell.descriptionLabel.text = "Variação do dia: "
            cell.numberLabel.text = "\(test)%"
            
            return cell
        
        // Savings Card
        }else if indexPath.row == 4{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "investmentsCell", for: indexPath) as! InvestmentsCell
            
            let test = 123
            
            cell.titleLabel.text = "Poupança"
            cell.valueLabel.text = "\(numberFormatter(value: data1[0].savingsValue))"
            cell.descriptionLabel.text = "Variação do dia: "
            cell.numberLabel.text = "\(test)%"
            
            return cell
            
        // ELSE
        }else{
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
            
            return 228
            
        }else{
            
            return 130
        }
    }
    
    
    // MARK: - Math Functions
    
    func calculatePercentage(value: Float) -> String{
        
        let totalInvestedValue = data1[0].stocksValue + data1[0].publicTitlesValue + data1[0].dollarValue + data1[0].savingsValue
        
        let percentage = (value * 100.0) / totalInvestedValue
        
        if floor(percentage) == percentage{
            return String(format: "%.0f", percentage)
            
        } else{
            return String(format: "%.1f", percentage)
        }
    }
    
    func numberFormatter(value: Float) -> String{
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "pt_BR")
        
        let valueString = currencyFormatter.string(from: NSNumber(value: value))
        
        return valueString!
    }
    
    func calculateChange(value1: Float, value2: Float) -> String{
        
        let change: Float = ((value2 - value1) / value1) * 100.0
        
        return String(format: "%.2f", change)
    }
    
    func stocksPriceOpen() -> Float{
        
        var allStocks: Float = 0.0
        
        for i in 0...index.count-1{
            allStocks += data2[index[i]].priceOpen
        }
        
        return allStocks
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
