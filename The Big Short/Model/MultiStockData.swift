//
//  StocksData.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 25/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class MultiStockData {
    
    var stocksArray: [String]
    
    init(stocksSelection: [String]) {
        stocksArray = stocksSelection
        worldTradingDataFetch()
    }
    
    struct Stocks{
        
        let price: String
        let change: String
        let changePercent: String
        
        init(json: [String: Any]) {
            
            if let data = json["data"] as? [Int: Any]{
                
                if let stock0 = data[0] as? [String: Any]{
                
                    price = stock0["price"] as? String ?? "ERRO1"
                    change = stock0["day_change"] as? String ?? "ERRO2"
                    changePercent = stock0["change_pct"] as? String ?? "ERRO3"
                
                } else{
                    price = "ERRO 111"
                    change = "ERRO 222"
                    changePercent = "ERRO 333"
                }
                
            } else{
                price = "ERRO 11"
                change = "ERRO 22"
                changePercent = "ERRO 33"
            }
        }
    }
    
    
    func worldTradingDataFetch(){
        
        let apiKey = "I2GqqSbulQG7poGGtxshyULZXcu0rGvbHdSsrC8ZTpqQqJAe1ssjmIGpFKnW"
        
        var stocks = "\(stocksArray[0]).SA"
        
        for i in 1...stocksArray.count-1{
            stocks += ",\(stocksArray[i]).SA"
        }
        
        let urlString = "https://api.worldtradingdata.com/api/v1/stock?symbol=\(stocks)&api_token=\(apiKey)"
        
        guard let url = URL(string: urlString) else{
            print("Erro 1")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                
                if let error = error{
                    print("Erro 2")
                    return
                }
                
                guard let data = data else{
                    print("Erro 3")
                    return
                }
                
                do{
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else{
                        return
                    }
                    
                    let stock = Stocks(json: json)
                    print(stock.price)
                    print(stock.change)
                    print(stock.changePercent)
                    
                } catch let err{
                    print(err.localizedDescription)
                }
            }
            
            }.resume()
    }
}

