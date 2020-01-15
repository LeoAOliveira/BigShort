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

class StocksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UNUserNotificationCenterDelegate {
    
    public var data1: [Wallet] = []
    public var data2: [Stock] = []
    var context: NSManagedObjectContext?
    
    var category: String!
    
    var index: [Int] = []
    var stockList = [String]()
    var selectedIndex = -1
    var selectedStock = " "
    
    var dataSource: String = "A"
    var dataUpdate: String = "A"
    
    var marketLabel: String = "A"
    var marketColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    var hasYDUQ3: Bool = false
    
    var removeNotifications = UNUserNotificationCenter.current()
    
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.0438792631, green: 0.1104110107, blue: 0.1780112088, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        verifyMarket(purpose: "keepTracking")
        fetchData()
        
        if data1[0].notifications == true{
            notifications()
        } else{
            removeNotifications.removeAllPendingNotificationRequests()
        }
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
                verifyUpdate()
                
            } catch{
                print(error.localizedDescription)
            }
        } else{
            dataUpdate = " "
            dataSource = " "
        }
        
        self.tableView.reloadData()
        
    }
    
    func verifyUpdate(){
        
        
        // Current date and last update
        
        let dateCurrent = Date()
        let lastUpdate = data1[0].lastUpdate!
        
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
        
        // Weekday
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEE"
        
        weekdayFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        
        let weekdayString = dayFormatter.string(from: dateCurrent)
        let lastUpdateWeekday = dayFormatter.string(from: lastUpdate)
        
        let needUpdate = true
        
        if weekdayString != "Saturday" && weekdayString != "Sunday"{
            
            if dayString > lastUpdateDay{
                
                updateStockData()
                
            } else if hourString > "17.00" {
                
                if lastUpdateHour <= "17.00" && lastUpdateHour < "23.59"{
                    updateStockData()
                }
                
            } else {
                
                let now = Float(hourString)!
                let lastUpdate = Float(lastUpdateHour)!
                
                let difference = now - lastUpdate
                
                if difference >= 1{
                    updateStockData()
                }
                
            }
            
        } else if weekdayString == "Saturday"{
            
            if lastUpdateWeekday == "Saturday" && (Int(dayString)! - Int(lastUpdateDay)!) != 0{
                updateStockData()
            
            } else if lastUpdateWeekday == "Friday" && lastUpdateHour > "17:00"{
            
            } else if lastUpdateDay < dayString{
                updateStockData()
            }
            
        } else if weekdayString == "Sunday"{
            
            if lastUpdateWeekday == "Saturday" && (Int(dayString)! - Int(lastUpdateDay)!) <= 1{
                
            } else if lastUpdateWeekday == "Friday" && lastUpdateHour > "17:00"{
                
            } else if lastUpdateDay < dayString{
                updateStockData()
            }
        }
    }
    
    func updateStockData(){
        
        var stocksArray = stockList
        
        for i in 0...stocksArray.count-1{
            
            if stocksArray[i] == "YDUQ3"{
                hasYDUQ3 = true
                stocksArray.remove(at: i)
            }
        }
        
        if stocksArray.count > 2{
            
            MultiStockData().worldTradingDataFetch(stocksArray: stocksArray, index: self.index){ isValid in
                
                if isValid == true{
                    print("YESS")
                    self.dataSource = "World Trading Data"
                    self.tableView.reloadData()
                    
                } else{
                    
                    self.createAlert(title: "Erro", message: "Não foi possível atualizar os dados. Por favor, tente novamente mais tarde.", actionTitle: "OK")
                }
            }
            
            if hasYDUQ3 == true{
                
                StockData().alphaVantageFetch(stocksArray: ["YDUQ3"], index: [65]){ isValid in
                    
                    if isValid == true{
                        print("YESS")
                        self.dataSource = "Alpha Vantage & World Trading Data"
                        self.tableView.reloadData()
                        
                    } else{
                        
                        self.createAlert(title: "Erro", message: "Não foi possível atualizar os dados. Por favor, tente novamente mais tarde.", actionTitle: "OK")
                    }
                    
                }
                
            }
            
        } else{
            
            StockData().alphaVantageFetch(stocksArray: self.stockList, index: self.index){ isValid in
                
                if isValid == true{
                    print("YESS")
                    self.dataSource = "Alpha Vantage"
                    self.tableView.reloadData()
                    
                } else{
                    
                    self.createAlert(title: "Erro", message: "Não foi possível atualizar os dados. Por favor, tente novamente mais tarde.", actionTitle: "OK")
                }
                
            }
        }
        
    }
    
    func saveContext(resultArray: [Array<String>]){
        // Array: [0] = open ; [1] = price ; [2] = changePercent
        
        for i in 0...stockList.count-1{
            
            do {
                
                let data1 = self.data1[0]
                data1.lastUpdate = Date()
                
                let data2 = self.data2[self.index[i]]
                data2.close = Float(resultArray[i][0])!
                data2.price = Float(resultArray[i][1])!
                // data2.change = resultArray[i][2]
                
                do{
                    try context!.save()
                    
                } catch{
                    print("Error when saving context (MSD)")
                }
                
            } catch {
                print("Erro ao inserir os dados de ações")
                print(error.localizedDescription)
            }
        }
    }
    
    func notifications(){
        
        removeNotifications.removeAllPendingNotificationRequests()
        
        if data1[0].notifications == true{
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    
                    // Abertura
                    let content1 = UNMutableNotificationContent()
                    content1.title = NSString.localizedUserNotificationString(forKey: "Mercado aberto", arguments: nil)
                    content1.sound = UNNotificationSound.default
                    
                    var dateConponents1 = DateComponents()
                    dateConponents1.hour = 10
                    dateConponents1.minute = 00
                    
                    
                    let trigger1 = UNCalendarNotificationTrigger(dateMatching: dateConponents1, repeats: false)
                    
                    let request1 = UNNotificationRequest(identifier: "market1", content: content1, trigger: trigger1)
                    
                    let center1 = UNUserNotificationCenter.current()
                    center1.add(request1) { (error : Error?) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    
                    // Fechamento
                    let content2 = UNMutableNotificationContent()
                    content2.title = NSString.localizedUserNotificationString(forKey: "Mercado fechado", arguments: nil)
                    content2.sound = UNNotificationSound.default
                    
                    var dateConponents2 = DateComponents()
                    dateConponents2.hour = 17
                    dateConponents2.minute = 00
                    
                    
                    let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateConponents2, repeats: false)
                    
                    let request2 = UNNotificationRequest(identifier: "market2", content: content2, trigger: trigger2)
                    
                    let center2 = UNUserNotificationCenter.current()
                    center2.add(request2) { (error : Error?) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    
                } else {
                    print("Impossível mandar notificação - permissão negada")
                }
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
            
            cell.marketLabel.text = marketLabel
            cell.marketView.backgroundColor = marketColor
            cell.marketView.layer.cornerRadius = cell.marketView.frame.size.width/2
            cell.marketView.clipsToBounds = true
            
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
                cell.incomeValueLabel.textColor = #colorLiteral(red: 0.1176470588, green: 0.6901960784, blue: 0.2549019608, alpha: 1)
            
            } else if incomeValue < 0{
                
                cell.incomeLabel.text = "Prejuízo: "
                cell.incomeValueLabel.text = "- \(numberFormatter(value: Float(incomeValue) * -1.0))"
                cell.incomeValueLabel.textColor = #colorLiteral(red: 0.7098039216, green: 0.1647058824, blue: 0.1647058824, alpha: 1)
            
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
            
            if stockList.count > 2{
                cell.sourceLabel.text = "Dados fornecidos por World Trading Data"
                
                if hasYDUQ3 == true{
                    cell.sourceLabel.text = "Dados de Alpha Vantage & World Trading Data"
                }
            
            } else{
                cell.sourceLabel.text = "Dados fornecidos por Alpha Vantage"
                
            }
            
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
            
            return 290
            
            
        }else{
            
            if (stockList.count + 1) <= 3{
                return 310
            
            } else{
                return 470
            }
            
            
        }
    }
    
    
    // MARK: - Collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return stockList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row != stockList.count{
            
            let cellCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "stockCollectionCell", for: indexPath) as! StockCollectionViewCell
            
            cellCollection.stockView.layer.cornerRadius = 10.0
            cellCollection.symbolLabel.text = data2[index[indexPath.row]].symbol
            
            let change = data2[index[indexPath.row]].change
            
            if data2[index[indexPath.row]].change < 0{
                cellCollection.changePercentageLabel.textColor = #colorLiteral(red: 0.7725490196, green: 0.06274509804, blue: 0.1254901961, alpha: 1)
                cellCollection.changePercentageLabel.text = "\(String(format: "%.2f", change))%"
                
            } else if data2[index[indexPath.row]].change > 0{
                cellCollection.changePercentageLabel.textColor = #colorLiteral(red: 0.1176470588, green: 0.6901960784, blue: 0.2549019608, alpha: 1)
                cellCollection.changePercentageLabel.text = "+\(String(format: "%.2f", change))%"
                
            } else{
                cellCollection.changePercentageLabel.text = "\(String(format: "%.2f", change))%"
                cellCollection.changePercentageLabel.textColor = #colorLiteral(red: 0.9408631921, green: 0.9652459025, blue: 0.9907889962, alpha: 1)
            }
            
            cellCollection.priceLabel.text = numberFormatter(value: data2[index[indexPath.row]].price)
            
                return cellCollection
        
        } else{
            
            let cellCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "addCollectionCell", for: indexPath) as! AddCollectionViewCell
            
            return cellCollection
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row <= stockList.count-1{
            selectedIndex = index[indexPath.row]
            selectedStock = data2[index[indexPath.row]].symbol!
            
            performSegue(withIdentifier: "detailStockSegue", sender: self)
        
        } else{
            
            if stockList.count >= 5{
                
                createAlert(title: "Limite de ações atingido", message: "Você pode possuir no máximo 5 ações diferentes.", actionTitle: "OK")
                
            } else{
                
                verifyMarket(purpose: "buyAndSell")
            }
        }
    }
    
    // MARK: - Create alert
    
    func createAlert(title: String, message: String, actionTitle: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let fillLabelAction = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(fillLabelAction)
        self.present(alert, animated: true, completion: nil)
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
    
    // MARK: - Market verification
    func verifyMarket(purpose: String){
        
        // Current date and last update
        let dateCurrent = Date()
        
        // Hour
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH.mm"
        hourFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        
        let hourString = hourFormatter.string(from: dateCurrent)
        
        // Weekend
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        dayFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        
        let dayString = dayFormatter.string(from: dateCurrent)
        
        if dayString == "Saturday" || dayString == "Sunday"{
            
            if purpose == "keepTracking"{
                
                marketColor = #colorLiteral(red: 0.1047265753, green: 0.2495177984, blue: 0.4248503447, alpha: 1)
                marketLabel = "Mercado fechado"
                
            } else{
                
                createAlert(title: "Mercado fechado", message: "Operações só podem ser realizadas em dias úteis.", actionTitle: "OK")
            }
            
        } else{
            
            if hourString < "10.00" || hourString > "17.00"{
                
                if purpose == "keepTracking"{
                    
                    marketColor = #colorLiteral(red: 0.1047265753, green: 0.2495177984, blue: 0.4248503447, alpha: 1)
                    marketLabel = "Mercado fechado"
                    
                } else{
                
                    createAlert(title: "Mercado fechado", message: "Operações só podem ser realizadas entre 10:00 e 17:00.", actionTitle: "OK")
                }
                
            } else{
                
                if purpose == "keepTracking"{
                    
                    marketColor = #colorLiteral(red: 0.4889312983, green: 0.7110515833, blue: 1, alpha: 1)
                    marketLabel = "Mercado aberto"
                    
                } else{
                
                    performSegue(withIdentifier: "addStockSegue", sender: self)
                }
            }
        }
    }

    
    // MARK: - Navigation
    
    @IBAction func addStockBtnPressed(_ sender: Any) {
        // verifyMarket(purpose: "buyAndSell")
        performSegue(withIdentifier: "addStockSegue", sender: self)
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
