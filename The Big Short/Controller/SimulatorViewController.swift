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
    
//    let dispatchGroup = DispatchGroup()
    
    var index: [Int] = []
    var stockList = [String]()
    
    var selectedInvestment = " "
    
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    // MARK: - Fetch from CoreData and Stock Data update
    
    func fetchData(){
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        index = []
        stockList = []
        
        data1.removeAll()
        data2.removeAll()
        
        do{
            data1 = try context!.fetch(Wallet.fetchRequest())
            data2 = try context!.fetch(Stock.fetchRequest())
            
            print(data2[1].symbol!)
            print(data2[1].price)
            print(data2[1].name!)
            
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
                    
                    for n in 0...65{
                        
                        if data2[n].symbol == stockList[i]{
                            index.append(n)
                        }
                    }
                }
                verifyUpdate()
                
                
            } catch{
                print(error.localizedDescription)
            }
        }
//        dispatchGroup.notify(queue: .main) {
        self.tableView.reloadData()
//        }
        
    }
    
    func verifyUpdate(){
        
        
        // Current date and last update

        let dateCurrent = Date()
        let lastUpdate = data1[0].lastUpdateStock!
        
        // Hour
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH.mm"
        
        hourFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")

        let hourString = hourFormatter.string(from: dateCurrent)
        let lastUpdateHour = hourFormatter.string(from: lastUpdate)
        
        // Day
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyMMdd"
        
        dayFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        
        let dayString = dayFormatter.string(from: dateCurrent)
        let lastUpdateDay = dayFormatter.string(from: lastUpdate)
        
        if dayString > lastUpdateDay{
            
            updateStockData()
            
        } else if hourString < "10.00"{

            if lastUpdateHour < "0.00"{
                updateStockData()
            }

        } else if hourString > "17.00" {

            if lastUpdateHour < "23.59"{
                updateStockData()
            }

        } else{
            
            let now = Float(hourString)!
            let lastUpdate = Float(lastUpdateHour)!

            let difference = now - lastUpdate
            let differenceInHours = floor(difference / 60 / 60)

            if differenceInHours >= 1{
                updateStockData()
            }

        }
    }
    
    func updateStockData(){
        
        if stockList.count > 2{
            
        } else{
            
            StockData().alphaVantageFetch(stocksArray: self.stockList, index: self.index){ isValid in
                
                if isValid == true{
                    print("YESS")
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
//    func saveContext(resultArray: [Array<String>]){
//        // Array: [0] = open ; [1] = price ; [2] = changePercent
//        
//        for i in 0...stockList.count-1{
//            
//            do {
//                
//                let data1 = self.data1[0]
//                data1.lastUpdate = Date()
//                
//                let data2 = self.data2[self.index[i]]
//                data2.close = Float(resultArray[i][0])!
//                data2.price = Float(resultArray[i][1])!
//                // data2.change = resultArray[i][2]
//                
//                do{
//                    try context!.save()
//                    
//                } catch{
//                    print("Error when saving context (MSD)")
//                }
//                
//            } catch {
//                print("Erro ao inserir os dados de ações")
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Wallet Card
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath) as! WalletCell
            
            cell.walletView.layer.cornerRadius = 10.0
            
            cell.titleLabel.text = "Carteira"
            cell.totalValueLabel.text = "\(numberFormatter(value: data1[0].totalValue))"
            cell.availableBalanceLabel.text = "Saldo disponível: \(numberFormatter(value: data1[0].availableBalance))"
            
            cell.stocksPercentageLabel.text = "\(calculatePercentage(value: data1[0].stocksValue))%"
            cell.stocksLabel.text = "Ações"
            
            cell.publicTitlesPercentageLabel.text = "\(calculatePercentage(value: data1[0].publicTitlesValue))%"
            cell.publicTitlesLabel.text = "Títulos públicos"
            
//            cell.dollarPercentageLabel.text = "\(calculatePercentage(value: data1[0].dollarValue))%"
//            cell.dollarLabel.text = "Dólar (USD)"
            
            cell.savingsPercentageLabel.text = "\(calculatePercentage(value: data1[0].savingsValue))%"
            cell.savingsLabel.text = "Poupança"
            
            return cell
            
            
//        // Stocks Card
//        } else if indexPath.row == 1{
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "investmentsCell", for: indexPath) as! InvestmentsCell
//
//            cell.investmentsView.layer.cornerRadius = 10.0
//
//            cell.titleLabel.text = "Ações"
//            selectedInvestment = "Ações"
//            cell.descriptionLabel.text = "Variação do dia: "
//
//            if index.count != 0 {
//
//                cell.valueLabel.text = "\(numberFormatter(value: positionPrice()))"
//
//                let change = calculateChange(value1: stocksPriceClose(), value2: positionPrice())
//
//
//                if change > 0.0{
//                    cell.numberLabel.textColor = #colorLiteral(red: 0, green: 0.7020406723, blue: 0.1667427123, alpha: 1)
//                    cell.numberLabel.text = "+\(String(format: "%.2f", change))%"
//
//                } else if change < 0.0{
//                    cell.numberLabel.textColor = #colorLiteral(red: 0.7722620368, green: 0.0615144521, blue: 0.1260437667, alpha: 1)
//                    cell.numberLabel.text = "\(String(format: "%.2f", change))%"
//
//                } else{
//                    cell.numberLabel.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
//                    cell.numberLabel.text = "\(String(format: "%.2f", change))%"
//                }
//
//            } else{
//                cell.valueLabel.text = "\(numberFormatter(value: 0.0))"
//                cell.numberLabel.text = "0,00%"
//                cell.numberLabel.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
//            }
//
//            return cell
//
//
//        // Public Titles Card
//        } else if indexPath.row == 2{
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "investmentsCell", for: indexPath) as! InvestmentsCell
//
//            let test = 123
//
//            cell.investmentsView.layer.cornerRadius = 10.0
//
//            cell.titleLabel.text = "Títulos públicos"
//            selectedInvestment = "Títulos públicos"
//            cell.valueLabel.text = "\(numberFormatter(value: data1[0].publicTitlesValue))"
//            cell.descriptionLabel.text = "Variação do dia: "
//            cell.numberLabel.text = "\(test)%"
//
//            return cell
//
//        // Dollar Card
//        }else if indexPath.row == 3{
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "investmentsCell", for: indexPath) as! InvestmentsCell
//
//            let test = 123
//
//            cell.investmentsView.layer.cornerRadius = 10.0
//
//            cell.titleLabel.text = "Dólar americano (USD)"
//            selectedInvestment = "Dólar americano (USD)"
//            cell.valueLabel.text = "\(numberFormatter(value: data1[0].dollarValue))"
//            cell.descriptionLabel.text = "Variação do dia: "
//            cell.numberLabel.text = "\(test)%"
//
//            return cell
//
//        // Savings Card
//        }else if indexPath.row == 4{
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "investmentsCell", for: indexPath) as! InvestmentsCell
//
//            let test = 123
//
//            cell.investmentsView.layer.cornerRadius = 10.0
//
//            cell.titleLabel.text = "Poupança"
//            selectedInvestment = "Poupança"
//            cell.valueLabel.text = "\(numberFormatter(value: data1[0].savingsValue))"
//            cell.descriptionLabel.text = "Variação do dia: "
//            cell.numberLabel.text = "\(test)%"
//
//            return cell
//
        // ELSE
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "investmentsCell", for: indexPath) as! InvestmentsCell
            
//            cell.investmentsView.layer.cornerRadius = 10.0
//            
//            cell.titleLabel.text = ""
//            cell.valueLabel.text = ""
//            cell.descriptionLabel.text = ""
//            cell.numberLabel.text = ""
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            
            return 228
            
        } else{
            
            return 130
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0{
            
            
        } else if indexPath.row == 1{
            
            performSegue(withIdentifier: "stocksSegue", sender: self)
            
        } else if indexPath.row == 2{
            selectedInvestment = "Títulos públicos"
            performSegue(withIdentifier: "investmentsSegue", sender: self)
            
        } else if indexPath.row == 3{
            selectedInvestment = "Dólar"
            performSegue(withIdentifier: "investmentsSegue", sender: self)
        } else if indexPath.row == 4{
            selectedInvestment = "Poupança"
            performSegue(withIdentifier: "investmentsSegue", sender: self)
            
        }
    }
    
    
    // MARK: - Math Functions
    
    func calculatePercentage(value: Float) -> String{
        
        // let totalInvestedValue = data1[0].stocksValue + data1[0].publicTitlesValue + data1[0].dollarValue + data1[0].savingsValue
        
        let totalInvestedValue = data1[0].stocksValue + data1[0].publicTitlesValue + data1[0].savingsValue
        
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
    
    func calculateChange(value1: Float, value2: Float) -> Float{
        
        let change: Float = ((value2 - value1) / value1) * 100.0
        
        return change
    }
    
    func stocksPriceClose() -> Float{
            
        var allStocks: Float = 0.0
        
        for i in 0...(stockList.count-1){
            allStocks += data2[index[i]].close * data2[index[i]].amount
        }
        
        return allStocks
    }
    
    
    func positionPrice() -> Float{
        
        var allStocks: Float = 0.0
        
        for i in 0...stockList.count-1{
            allStocks += data2[index[i]].price * data2[index[i]].amount
        }
        
        return allStocks
    }
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "investmentsSegue"{
            
            let destination = segue.destination as! InvestmentsViewController
            
            // destination.selectedInvestment = selectedInvestment
            
        }
     }
    

}
