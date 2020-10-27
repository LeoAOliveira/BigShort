//
//  MarketData.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 07/08/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//


import Foundation
import CoreData
import UIKit

class MarketData {
    
    var data1 = [Wallet]()
    var data2 = [Stock]()
    var data4 = [Currency]()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    struct Market {
        
        var stockDataPrices = [String: Float]()
        var stockDataChanges = [String: String]()
        var currencyData = [String: Float]()
        
        init(json: [Dictionary<String,Any>]) {
            
            for i in 0..<json.count {
                    
                if let data = json[i] as? [String: Any] {
                    
                    let type = data["type"] as? String ?? "-1"
                    let code = data["code"] as? String ?? "-1"
                    let price = data["price"] as? String ?? "-1"
                    let change = data["change"] as? String ?? "-1"
                    
                    if type == "Stock" {
                        
                        if let floatPrice = Float(price) {
                            stockDataPrices[code] = floatPrice
                            stockDataChanges[code] = change
                        } else {
                            stockDataPrices[code] = -1.0
                            stockDataChanges[code] = "-1.0"
                        }
                        
                    } else {
                        currencyData[code] = Float(price)
                    }
                    
                } else {
                    
                    let code = "-1"
                    let price: Float = -1.0
                    let change = "-1"
                    
                    stockDataPrices[code] = price
                    stockDataChanges[code] = change
                    currencyData[code] = price
                }
            }
        }
    }
    
    
    func marketDataFetch(completion: @escaping (Bool) -> ()){
        
        let urlString = "https://sheetlabs.com/LOGS/MarketDataAPI"
        
        guard let url = URL(string: urlString) else{
            print("Erro 1")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                
                if let error = error {
                    print("Erro 2")
                    completion(false)
                    return
                }
                
                guard let data = data else{
                    print("Erro 3")
                    completion(false)
                    return
                }
                
                do {
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Dictionary<String,Any>] else{
                        completion(false)
                        return
                    }
                    
                    let market = Market(json: json)
                    
                    do {
                        self.data1 = try self.context.fetch(Wallet.fetchRequest())
                        self.data2 = try self.context.fetch(Stock.fetchRequest())
                        self.data4 = try self.context.fetch(Currency.fetchRequest())
                        
                        let data1 = self.data1[0]
                        data1.lastUpdateStock = Date()
                        data1.lastUpdateCurrency = Date()
                        
                        let sortedData2 = self.data2.sorted(by: { $0.symbol ?? "" < $1.symbol ?? "" })
                        self.data2 = sortedData2
                        
                        let sortedData4 = self.data4.sorted(by: { $0.symbol ?? "" < $1.symbol ?? "" })
                        self.data4 = sortedData4
                        
                        var stockPricesArray: [Float] = []
                        var stockChangesArray: [String] = []
                        var currencyPricesArray: [Float] = []
                        
                        
                        for (key,value) in market.stockDataPrices.sorted(by: <) {
                            stockPricesArray.append(value)
                        }
                        
                        for (key,value) in market.stockDataChanges.sorted(by: <) {
                            stockChangesArray.append(value)
                        }
                        
                        for (key,value) in market.currencyData.sorted(by: <) {
                            currencyPricesArray.append(value)
                        }
                        
                        for i in 0..<market.stockDataPrices.count {
                            
                            let data2 = self.data2[i]
                            data2.price = Float(stockPricesArray[i])
                            data2.changePercentage = String(stockChangesArray[i])
                            
                            do {
                                try self.context.save()
                                
                            } catch{
                                completion(false)
                                print("Error when saving context (Stocks)")
                            }
                        }
                        
                        for i in 0..<market.currencyData.count {
                            
                            let data4 = self.data4[i]
                            data4.price = Float(currencyPricesArray[i])
                            
                            do {
                                try self.context.save()
                                
                            } catch{
                                completion(false)
                                print("Error when saving context (Currency)")
                            }
                        }
                        
                    } catch {
                        completion(false)
                        print("Erro ao inserir os dados de ações")
                        print(error.localizedDescription)
                    }
                    
                } catch let err{
                    completion(false)
                    print(err.localizedDescription)
                }
                
                completion(true)
            }
            
        }.resume()
    }
}
