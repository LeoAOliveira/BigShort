//
//  CoreDataManager.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 17/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData

class StockDataManager: NSObject {
    
    weak var mainViewController: MainViewController?
    
    var context: NSManagedObjectContext?
    
    var data1: [Wallet] = []
    var data2: [Stock] = []
    var index: [Int] = []
    var stockList = [String]()
    var hasYDUQ3: Bool = false
    
    init(viewController: MainViewController) {
        super.init()
        self.mainViewController = viewController
    }
    
    // MARK: - Fetch stocks in CoreData
    func fetchData(completion: @escaping (Bool) -> () ){
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
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
                
                if verifyUpdate() == true {
                    updateStockData()
                }
                
            } catch{
                print(error.localizedDescription)
            }
        } else{
           
            self.mainViewController?.infoUpdate = " "
            self.mainViewController?.infoSource = " "
        }
        
        guard let mainVC = mainViewController else {
            completion(false)
            return
        }
        
        mainVC.data1 = data1
        mainVC.data2 = data2
        mainVC.stockList = stockList
        mainVC.index = index
        
        mainVC.tableView.reloadData()
        
        completion(true)
    }
    
    // MARK: - Check the need for update
    func verifyUpdate() -> Bool {
        
        // Current date and last update
        
        let dateCurrent = Date()
        
        guard let lastUpdate = data1[0].lastUpdate else {
            return true
        }
        
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
        
        if weekdayString != "Saturday" && weekdayString != "Sunday"{
            
            if dayString > lastUpdateDay{
                
                return true
                
            } else if hourString > "17.00" {
                
                if lastUpdateHour <= "17.00" && lastUpdateHour < "23.59"{
                    return true
                }
                
            } else {
                
                let now = Float(hourString)!
                let lastUpdate = Float(lastUpdateHour)!
                
                let difference = now - lastUpdate
                
                if difference >= 1{
                    return true
                }
                
            }
            
        } else if weekdayString == "Saturday"{
            
            if lastUpdateWeekday == "Saturday" && (Int(dayString)! - Int(lastUpdateDay)!) != 0{
                return true
            
            } else if lastUpdateWeekday == "Friday" && lastUpdateHour > "17:00"{
            
            } else if lastUpdateDay < dayString{
                return true
            }
            
        } else if weekdayString == "Sunday"{
            
            if lastUpdateWeekday == "Saturday" && (Int(dayString)! - Int(lastUpdateDay)!) <= 1{
                
            } else if lastUpdateWeekday == "Friday" && lastUpdateHour > "17:00"{
                
            } else if lastUpdateDay < dayString{
                return true
            }
        }
        
        return false
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
                    self.mainViewController?.infoSource = "World Trading Data"
                    self.mainViewController?.tableView.reloadData()
                    
                } else{
                    
                    self.mainViewController?.createAlert(title: "Erro", message: "Não foi possível atualizar os dados. Por favor, tente novamente mais tarde.", actionTitle: "OK")
                }
            }
            
            if hasYDUQ3 == true{
                
                StockData().alphaVantageFetch(stocksArray: ["YDUQ3"], index: [65]){ isValid in
                    
                    if isValid == true{
                        print("YESS")
                        self.mainViewController?.infoSource = "Alpha Vantage & World Trading Data"
                        self.mainViewController?.tableView.reloadData()
                        
                    } else{
                        
                        self.mainViewController?.createAlert(title: "Erro", message: "Não foi possível atualizar os dados. Por favor, tente novamente mais tarde.", actionTitle: "OK")
                    }
                    
                }
                
            }
            
        } else{
            
            StockData().alphaVantageFetch(stocksArray: self.stockList, index: self.index){ isValid in
                
                if isValid == true{
                    print("YESS")
                    self.mainViewController?.infoSource = "Alpha Vantage"
                    self.mainViewController?.tableView.reloadData()
                    
                } else{
                    
                    self.mainViewController?.createAlert(title: "Erro", message: "Não foi possível atualizar os dados. Por favor, tente novamente mais tarde.", actionTitle: "OK")
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
                    print(error.localizedDescription)
                }
                
            } catch {
                print("Erro ao inserir os dados de ações")
                print(error.localizedDescription)
            }
        }
    }
    
}
