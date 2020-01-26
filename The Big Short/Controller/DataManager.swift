//
//  CoreDataManager.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 17/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    
    weak var mainViewController: MainViewController?
    weak var stocksViewController: StocksViewController?
    weak var currenciesViewController: CurrenciesViewController?
    
    var context: NSManagedObjectContext?
    
    var data1: [Wallet] = []
    var data2: [Stock] = []
    var data4: [Currency] = []
    
    var indexStock: [Int] = []
    var stockList = [String]()
    
    var indexCurrency: [Int] = []
    var currencyList = [String]()
    
    init(mainViewController: MainViewController? = nil, stocksViewController: StocksViewController? = nil, currenciesViewController: CurrenciesViewController? = nil) {
        super.init()
        self.mainViewController = mainViewController
        self.stocksViewController = stocksViewController
        self.currenciesViewController = currenciesViewController
    }
    
    func sortStocks() {
        let sortedData2 = self.data2.sorted(by: { $0.symbol! < $1.symbol! })
        data2 = sortedData2
        
        do {
            try self.context?.save()
            
        } catch{
            print("Error when sorting")
        }
    }
    
    // MARK: - Fetch stocks in CoreData
    func fetchData(completion: @escaping (Bool) -> () ){
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        data1.removeAll()
        data2.removeAll()
        
        do{
            data1 = try context!.fetch(Wallet.fetchRequest())
            data2 = try context!.fetch(Stock.fetchRequest())
            data4 = try context!.fetch(Currency.fetchRequest())
            
        } catch{
            print(error.localizedDescription)
        }
        
        sortStocks()
        getStocks()
        getCurrencies()
        
        if mainViewController != nil {
            
            guard let mainVC = mainViewController else {
                completion(false)
                return
            }

            mainVC.data1 = data1
            mainVC.data2 = data2
            mainVC.data4 = data4
            mainVC.stockList = stockList
            mainVC.stockIndex = indexStock
            mainVC.currencyList = currencyList
            mainVC.currencyIndex = indexCurrency

            mainVC.tableView.reloadData()
        
        } else if stocksViewController != nil {
            
            guard let stocksVC = stocksViewController else {
                completion(false)
                return
            }

            stocksVC.data1 = data1
            stocksVC.data2 = data2
            stocksVC.stockList = stockList
            stocksVC.index = indexStock
            
            stocksVC.tableView.reloadData()
            
        } else {
            
            guard let currenciesVC = currenciesViewController else {
                completion(false)
                return
            }

            currenciesVC.data1 = data1
            currenciesVC.data4 = data4
            currenciesVC.currencyList = currencyList
            currenciesVC.currencyIndex = indexCurrency

            currenciesVC.tableView.reloadData()
            
        }
        
        completion(true)
    }
    
    func getStocks() {
        
        let stocks = data1[0].stockList
        
        if stocks != "" {
            stockList = stocks?.components(separatedBy: ":") ?? []
        }
        
        if stockList.count > 0 {
            
            for i in 0...stockList.count-1{
                
                for n in 0...72 {
                    
                    if data2[n].symbol == stockList[i]{
                        indexStock.append(n)
                    }
                }
            }
        }
        
        if stockList.count >= 1 || stocksViewController != nil {
            
            do {
                
                if verifyStocksUpdate() == true {
                    StockData().stocksDataFetch()
                }
                
                StockData().stocksDataFetch()
                
            } catch{
                print(error.localizedDescription)
            }
            
        }
    }
    
    func getCurrencies() {
        
        let currencies = data1[0].currencyList
        
        if currencies != "" {
            currencyList = currencies?.components(separatedBy: ":") ?? []
        }
        
        if currencyList.count > 0 {
            
            for i in 0...currencyList.count-1{
                
                for n in 0...47 {
                    
                    if data4[n].symbol == currencyList[i]{
                        indexCurrency.append(n)
                    }
                }
            }
        }
        
        if currencyList.count >= 1 || currenciesViewController != nil {
            
            do {
                
                if verifyCurrencyUpdate() == true {
                    CurrencyData().exchangeRatesFetch()
                }
                
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Check the need for stocks update
    func verifyStocksUpdate() -> Bool {
        
        // Current date and last update
        
        let dateCurrent = Date()
        
        guard let lastUpdate = data1[0].lastUpdateStock else {
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
    
    // MARK: - Check the need for currency update
      func verifyCurrencyUpdate() -> Bool {
          
          // Current date and last update
          
          let dateCurrent = Date()
          
          guard let lastUpdate = data1[0].lastUpdateCurrency else {
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
          
          if dayString > lastUpdateDay{
              return true
              
          } else {
              
              let now = Float(hourString)!
              let lastUpdate = Float(lastUpdateHour)!
              
              let difference = now - lastUpdate
              
              if difference >= 1{
                  return true
              }
          }
          return false
    }
    
}
