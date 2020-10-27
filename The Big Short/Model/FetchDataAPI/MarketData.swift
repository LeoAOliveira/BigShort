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

    func marketDataFetch(completion: @escaping (Bool) -> ()){
        
        let urlString = "https://docs.google.com/spreadsheets/d/e/2PACX-1vSPIn1eQkrkpkBqfvmhmElvez8kMs8MKEno4z9Fnf69IGZ4h56rTN7UkqVLWfdeZ0kOy2bDp7xrnzWs/pub?gid=0&single=true&output=tsv"
        
        guard let url = URL(string: urlString) else{
            print("Erro 1")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                
                if let error = error {
                    print("Erro 2: \(error)")
                    completion(false)
                    return
                }
                
                guard let data = data else{
                    print("Erro 3")
                    completion(false)
                    return
                }
                
                var data1 = [Wallet]()
                var data2 = [Stock]()
                var data4 = [Currency]()
                
                guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
                    completion(false)
                    return
                }
                
                var stockDataPrices = [String: Float]()
                var stockDataChanges = [String: String]()
                var currencyData = [String: Float]()
                
                let tsv = String(decoding: data, as: UTF8.self)
                
                let lines = tsv.components(separatedBy: "\n")
                var lineIndex = 1
                
                guard lines.isEmpty == false else {
                    return
                }
                
                for line in lines[lineIndex ..< lines.count] {
                    
                    let fieldValues = line.components(separatedBy: "\t")
                    
                    let type = fieldValues[0]
                    let code = fieldValues[1]
                    let price = fieldValues[2]
                    let change = fieldValues[3].replacingOccurrences(of: "\r", with: "")
                    
                    if type == "Stock" {
                        stockDataPrices[code] = Float(price)
                        stockDataChanges[code] = change
                    } else {
                        currencyData[code] = Float(price)
                    }
                    lineIndex = lineIndex + 1
                }
                
                do {
                    data1 = try context.fetch(Wallet.fetchRequest())
                    data2 = try context.fetch(Stock.fetchRequest())
                    data4 = try context.fetch(Currency.fetchRequest())
                    
                    let data1 = data1[0]
                    data1.lastUpdateStock = Date()
                    data1.lastUpdateCurrency = Date()
                    
                    let sortedData2 = data2.sorted(by: { $0.symbol ?? "" < $1.symbol ?? "" })
                    data2 = sortedData2
                    
                    let sortedData4 = data4.sorted(by: { $0.symbol ?? "" < $1.symbol ?? "" })
                    data4 = sortedData4
                    
                    var stockPricesArray: [Float] = []
                    var stockChangesArray: [String] = []
                    var currencyPricesArray: [Float] = []
                    
                    
                    for (key,value) in stockDataPrices.sorted(by: <) {
                        stockPricesArray.append(value)
                    }
                    
                    for (key,value) in stockDataChanges.sorted(by: <) {
                        stockChangesArray.append(value)
                    }
                    
                    for (key,value) in currencyData.sorted(by: <) {
                        currencyPricesArray.append(value)
                    }
                    
                    for i in 0..<stockDataPrices.count {
                        
                        let data2 = data2[i]
                        data2.price = Float(stockPricesArray[i])
                        data2.changePercentage = String(stockChangesArray[i])
                        
                        do {
                            try context.save()
                            
                        } catch{
                            completion(false)
                            print("Error when saving context (Stocks)")
                        }
                    }
                    
                    for i in 0..<currencyData.count {
                        
                        let data4 = data4[i]
                        data4.price = Float(currencyPricesArray[i])
                        
                        do {
                            try context.save()
                            
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
                completion(true)
            }
        }.resume()
    }
}
