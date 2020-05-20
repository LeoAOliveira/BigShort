//
//  StocksData.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 25/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class StockData {
    
    var data1 = [Wallet]()
    var data2 = [Stock]()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    struct Stocks {
        
        var prices = [String: Float]()
        var changes = [String: String]()
        
        init(json: [String: Any]) {
            
            if let data = json["response"] as? [Dictionary<String,Any>] {
                
                for i in 0...72 {
                    
                    if let stock = data[i] as? [String: Any] {
                        
                        let symbol = stock["symbol"] as? String ?? "-1"
                        let price = stock["price"] as? String ?? "-1"
                        let change = stock["chg_percent"] as? String ?? "-1"
                        
                        prices[symbol] = Float(price)
                        changes[symbol] = change
                    }
                }
                
            } else{
                
                let symbol = "-1"
                let price = "-1"
                let change = "-1"
                
                prices[symbol] = Float(price)
                changes[symbol] = change
            }
        }
    }
    
    
    func stocksDataFetch(completion: @escaping (Bool) -> ()){
        
        let urlString = "https://fcsapi.com/api-v2/stock/latest?id=105746,105747,105748,105749,105750,105751,105752,105753,105754,105755,105756,105757,105758,105759,105760,105761,105762,105763,105764,105765,105766,105767,105768,105769,105770,105771,105772,105773,105774,105775,105776,105777,105778,105779,105780,105781,105782,105783,105784,105785,105786,105787,105788,105789,105790,105791,105792,105793,105794,105795,105796,105797,105798,105799,105800,105801,105802,105803,105804,105805,105806,105807,105808,105809,105810,105811,105812,105813,105900,105939,105943,105982,105988&access_key=JvVn0G72MS2Ab0WcprB68I2CUXOowawWEIcoTqHPFgf3scwFjw"
        
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
                
                do{
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else{
                        completion(false)
                        return
                    }
                    
                    let stocks = Stocks(json: json)
                    
                    do {
                        self.data1 = try self.context.fetch(Wallet.fetchRequest())
                        self.data2 = try self.context.fetch(Stock.fetchRequest())
                        
                        let data1 = self.data1[0]
                        data1.lastUpdateStock = Date()
                        
                        let sortedData2 = self.data2.sorted(by: { $0.symbol ?? "" < $1.symbol ?? "" })
                        self.data2 = sortedData2
                        
                        let orderedPrices = stocks.prices.sorted(by: <)
                        var pricesArray: [Float] = []
                        
                        let orderedChanges = stocks.changes.sorted(by: <)
                        var changesArray: [String] = []
                        
                        for (key,value) in orderedPrices {
                            pricesArray.append(value)
                        }
                        
                        for (key,value) in orderedChanges {
                            changesArray.append(value)
                        }
                        
                        for i in 0...72 {
                            
                            let data2 = self.data2[i]
                            data2.price = Float(pricesArray[i])
                            data2.changePercentage = String(changesArray[i])
                            
                            do {
                                try self.context.save()
                                
                            } catch{
                                completion(false)
                                print("Error when saving context (Stocks)")
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
