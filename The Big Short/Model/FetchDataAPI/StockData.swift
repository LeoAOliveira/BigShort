//
//  StocksData.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 25/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

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
        
        let urlString = "https://fcsapi.com/api/stock/latest?id=105746,105747,105748,105749,105750,105751,105752,105753,105754,105755,105756,105757,105758,105759,105760,105761,105762,105763,105764,105765,105766,105767,105768,105769,105770,105771,105772,105773,105774,105775,105776,105777,105778,105779,105780,105781,105782,105783,105784,105785,105786,105787,105788,105789,105790,105791,105792,105793,105794,105795,105796,105797,105798,105799,105800,105801,105802,105803,105804,105805,105806,105807,105808,105809,105810,105811,105812,105813,105900,105939,105943,105982,105988&access_key=JvVn0G72MS2Ab0WcprB68I2CUXOowawWEIcoTqHPFgf3scwFjw"
        
        guard let url = URL(string: urlString) else{
            print("Erro 1")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                
                if let error = error{
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
                        data1.lastUpdateCurrency = Date()
                        
                        let sortedData2 = self.data2.sorted(by: { $0.symbol! < $1.symbol! })
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
                            data2.change = String(changesArray[i])
                            
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

//class MultiStockData {
//
//    var resultsArray: [Array<String>] = []
//
//    public var data1 = [Wallet]()
//    public var data2 = [Stock]()
//
//    let dispatchGroup = DispatchGroup()
//
//    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    func downloadData(completion: @escaping () -> Void){
//
//        let deadline = DispatchTime.now()
//
//        DispatchQueue.main.asyncAfter(deadline: deadline) {
//            completion()
//        }
//    }
//
//    struct Stocks{
//
//        let price: String
//        let close: String
//        let change: String
//        let changePercent: String
//
//        init(json: [String: Any], index: Int) {
//
//            if let data = json["data"] as? [Dictionary<String,Any>]{
//
//                if let stock0 = data[index] as? [String: Any]{
//
//                    price = stock0["price"] as? String ?? "ERRO1"
//                    close = stock0["close_yesterday"] as? String ?? "ERRO2"
//                    change = stock0["day_change"] as? String ?? "ERRO3"
//                    changePercent = stock0["change_pct"] as? String ?? "ERRO4"
//
//                } else{
//                    price = "ERRO 111"
//                    close = "ERRO 222"
//                    change = "ERRO 333"
//                    changePercent = "ERRO 444"
//                }
//
//            } else{
//                price = "ERRO 11"
//                close = "ERRO 22"
//                change = "ERRO 33"
//                changePercent = "ERRO 44"
//            }
//        }
//    }
//
//
//    func worldTradingDataFetch(stocksArray: [String], index: [Int], completion: @escaping (Bool) -> () ){
//
//        let apiKey = "I2GqqSbulQG7poGGtxshyULZXcu0rGvbHdSsrC8ZTpqQqJAe1ssjmIGpFKnW"
//
//        var stocks = "\(stocksArray[0]).SA"
//
//        for i in 1...stocksArray.count-1{
//            stocks += ",\(stocksArray[i]).SA"
//        }
//
//        let urlString = "https://api.worldtradingdata.com/api/v1/stock?symbol=\(stocks)&api_token=\(apiKey)"
//
//        guard let url = URL(string: urlString) else{
//            print("Erro 1")
//            completion(false)
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            DispatchQueue.main.async {
//
//                if let error = error{
//                    print("Erro 2")
//                    completion(false)
//                }
//
//                guard let data = data else{
//                    print("Erro 3")
//                    completion(false)
//                    return
//                }
//
//                for i in 0..<stocksArray.count{
//
//                    do{
//
//                        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else{
//                            return
//                        }
//
//                        let stock = Stocks(json: json, index: i)
//
//                        do{
//
//                            self.data1 = try self.context.fetch(Wallet.fetchRequest())
//                            self.data2 = try self.context.fetch(Stock.fetchRequest())
//
//                            let data1 = self.data1[0]
//                            data1.lastUpdateStock = Date()
//
//                            // for i in 0...stocksArray.count-1 {
//
//                            let data2 = self.data2[index[i]]
//                            data2.close = Float(stock.close)!
//                            data2.price = Float(stock.price)!
//
//                            data2.change = ((data2.price - data2.close) / data2.close) * 100.0
//
//                            do{
//                                try self.context.save()
//
//                            } catch{
//                                print("Error when saving context (MSD)")
//                                completion(false)
//                            }
//                           //  }
//
//                        } catch {
//                            print("Erro ao inserir os dados de ações")
//                            print(error.localizedDescription)
//                            completion(false)
//                        }
//
//                        // Array: [0] = open ; [1] = price ; [2] = changePercent
//
//                    } catch let err{
//                        print(err.localizedDescription)
//                        completion(false)
//                    }
//                }
//
//                completion(true)
//
//            }
//
//        }.resume()
//    }
//
//}
