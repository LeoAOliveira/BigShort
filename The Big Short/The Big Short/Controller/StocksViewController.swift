//
//  InvestmentViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 26/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class StocksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public var data1: [Wallet] = []
    public var data2: [Stock] = []
    var context: NSManagedObjectContext?
    
    var category: String!
    
    var index: [Int] = []
    var stockList = [String]()
    var selectedIndex = -1
    var selectedStock = " "
    
    var hasLoadedData = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        notifications()
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
                
            } catch{
                print(error.localizedDescription)
            }
        }
        
        tableView.reloadData()
    }
    
    func notifications(){
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "Fechamneto do mercado", arguments: nil)
//                content.body = NSString.localizedUserNotificationString(forKey: "Você se lembrou", arguments: nil)
                content.sound = UNNotificationSound.default
                
                var dateConponents = DateComponents()
                dateConponents.hour = 17
                dateConponents.minute = 00
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateConponents, repeats: false)
                
                let request = UNNotificationRequest(identifier: "market", content: content, trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                center.add(request) { (error : Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            } else {
                print("Impossível mandar notificação - permissão negada")
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Position Card
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "positionCell", for: indexPath) as! PositionCell
            
            cell.positionView.layer.cornerRadius = 10.0
            
            cell.titleLabel.text = "Posição"
            cell.balanceLabel.text = "Saldo disponível: \(numberFormatter(value: data1[0].availableBalance))"
            
            var incomeValue = 0.0
            
            if stockList.count == 0{
                cell.totalValueLabel.text = numberFormatter(value: 0.0)
                cell.investedValueLabel.text = "Valor investido: \(numberFormatter(value: 0.0))"
            
            } else{
                cell.totalValueLabel.text = numberFormatter(value: stocksCurrentPrice())
                incomeValue = Double(calculateIncome(value1: stocksCurrentPrice(), value2: investedValue()))
                cell.investedValueLabel.text = "Valor investido: \(numberFormatter(value: investedValue()))"
            }
            
            if incomeValue > 0{
                
                cell.incomeLabel.text = "Rendimento: "
                cell.incomeValueLabel.text = "+ \(numberFormatter(value: Float(incomeValue)))"
                cell.incomeValueLabel.textColor = #colorLiteral(red: 0, green: 0.7020406723, blue: 0.1667427123, alpha: 1)
            
            } else if incomeValue < 0{
                
                cell.incomeLabel.text = "Prejuízo: "
                cell.incomeValueLabel.text = "- \(numberFormatter(value: Float(incomeValue)))"
                cell.incomeValueLabel.textColor = #colorLiteral(red: 0.7722620368, green: 0.0615144521, blue: 0.1260437667, alpha: 1)
            
            } else{
                cell.incomeLabel.text = "Rendimento: "
                cell.incomeValueLabel.text = numberFormatter(value: Float(incomeValue))
                cell.incomeValueLabel.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
            }
            
            
            return cell
            
            
        // Stocks Card
        } else if indexPath.row == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "stocksCell", for: indexPath) as! StockCell
            
            cell.stocksView.layer.cornerRadius = 10.0
            
            cell.titleLabel.text = "Meus ativos"
            
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            
            cell.lastUpdateLabel.text = "Última atualização: \(formatDate())"
            
            cell.collectionView.reloadData()
            
            return cell
            
            
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
            
            return 250
            
        }else{
            
            if stockList.count <= 3{
                return 265
            
            } else{
                return 410
            }
            
            
        }
    }
    
    
    // MARK: - Collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return stockList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row != stockList.count{
            
            let cellCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "stockCollectionCell", for: indexPath) as! StockCollectionViewCell
            
            cellCollection.stockView.layer.cornerRadius = 10.0
            cellCollection.symbolLabel.text = data2[index[indexPath.row]].symbol
            
            let change = data2[index[indexPath.row]].change
            
            if data2[index[indexPath.row]].change < 0{
                cellCollection.changePercentageLabel.textColor = #colorLiteral(red: 0.7722620368, green: 0.0615144521, blue: 0.1260437667, alpha: 1)
                cellCollection.changePercentageLabel.text = "\(String(format: "%.2f", change))%"
                
            } else if data2[index[indexPath.row]].change > 0{
                cellCollection.changePercentageLabel.textColor = #colorLiteral(red: 0, green: 0.7020406723, blue: 0.1667427123, alpha: 1)
                cellCollection.changePercentageLabel.text = "+\(String(format: "%.2f", change))%"
                
            } else{
                cellCollection.changePercentageLabel.text = "\(String(format: "%.2f", change))%"
                cellCollection.changePercentageLabel.textColor = #colorLiteral(red: 0.9408631921, green: 0.9652459025, blue: 0.9907889962, alpha: 1)
            }
            
            cellCollection.priceLabel.text = numberFormatter(value: data2[index[indexPath.row]].price)
            
                return cellCollection
        
        } else{
            
            let cellCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "stockCollectionCell", for: indexPath) as! StockCollectionViewCell
            
            cellCollection.stockView.layer.cornerRadius = 10.0
            
            return cellCollection
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = index[indexPath.row]
        selectedStock = data2[index[indexPath.row]].symbol!
        
        performSegue(withIdentifier: "detailStockSegue", sender: self)
        
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
        
        let lastUpdate = data1[0].lastUpdate!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        dateFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        
        return dateFormatter.string(from: lastUpdate)
    }
    
    func stocksPriceClose() -> Float{
        
        var allStocks: Float = 0.0
        
        for i in 0...(stockList.count-1){
            allStocks += data2[index[i]].close
        }
        
        return allStocks
    }
    
    func stocksCurrentPrice() -> Float{
        
        var allStocks: Float = 0.0
        
        for i in 0...stockList.count-1{
            allStocks += data2[index[i]].price * data2[index[i]].amount
        }
        
        return allStocks
    }
    
    func investedValue() -> Float{
        
        var allStocks: Float = 0.0
        
        for i in 0...stockList.count-1{
            allStocks += data2[index[i]].invested
        }
        
        return allStocks
        
    }
    


    // MARK: - Navigation
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "detailStockSegue"{

            // selectedStock = (sender as! StockCollectionViewCell).symbolLabel.text!
            
            let destination = segue.destination as! SymbolViewController

            destination.index = selectedIndex
            destination.selectedStock = selectedStock

        }
    }

}
