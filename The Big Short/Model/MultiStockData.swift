//
//  StocksData.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 25/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class MultiStockData {
    
    var resultsArray: [Array<String>] = []
    
    public var data1 = [Wallet]()
    public var data2 = [Stock]()
    
    let dispatchGroup = DispatchGroup()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func downloadData(completion: @escaping () -> Void){
        
        let deadline = DispatchTime.now()
        
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    
    struct Stocks{
        
        let price: String
        let close: String
        let change: String
        let changePercent: String
        
        init(json: [String: Any]) {
            
            if let data = json["data"] as? [Dictionary<String,Any>]{
                
                if let stock0 = data[0] as? [String: Any]{
                
                    price = stock0["price"] as? String ?? "ERRO1"
                    close = stock0["close_yesterday"] as? String ?? "ERRO2"
                    change = stock0["day_change"] as? String ?? "ERRO3"
                    changePercent = stock0["change_pct"] as? String ?? "ERRO4"
                
                } else{
                    price = "ERRO 111"
                    close = "ERRO 222"
                    change = "ERRO 333"
                    changePercent = "ERRO 444"
                }
                
            } else{
                price = "ERRO 11"
                close = "ERRO 22"
                change = "ERRO 33"
                changePercent = "ERRO 44"
            }
        }
    }
    
    
    func worldTradingDataFetch(stocksArray: [String], index: [Int], completion: @escaping (Bool) -> () ){
        
        let apiKey = "I2GqqSbulQG7poGGtxshyULZXcu0rGvbHdSsrC8ZTpqQqJAe1ssjmIGpFKnW"
        
        var stocks = "\(stocksArray[0]).SA"
        
        for i in 1...stocksArray.count-1{
            stocks += ",\(stocksArray[i]).SA"
        }
        
        let urlString = "https://api.worldtradingdata.com/api/v1/stock?symbol=\(stocks)&api_token=\(apiKey)"
        
        // let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=\(stockString)&apikey=\(apiKey)"
        
        // https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=ABEV3.SA&apikey=COR1E5U5AX51SRR7
        
        guard let url = URL(string: urlString) else{
            print("Erro 1")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                
                if let error = error{
                    print("Erro 2")
                    completion(false)
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
                    
                    do {
                        
                        self.data1 = try self.context.fetch(Wallet.fetchRequest())
                        self.data2 = try self.context.fetch(Stock.fetchRequest())
                        
                        let data1 = self.data1[0]
                        data1.lastUpdate = Date()
                        
                        for i in 0...stocksArray.count-1{
                            
                            let data2 = self.data2[index[i]]
                            data2.close = Float(stock.close)!
                            data2.price = Float(stock.price)!
                            
                            data2.change = ((data2.price - data2.close) / data2.close) * 100.0

                            do{
                                try self.context.save()
                                
                            } catch{
                                print("Error when saving context (MSD)")
                            }
                        }
                        
                        completion(true)
                        
                    } catch {
                        print("Erro ao inserir os dados de ações")
                        print(error.localizedDescription)
                    }
                    
                    // Array: [0] = open ; [1] = price ; [2] = changePercent
                    
                } catch let err{
                    print(err.localizedDescription)
                }
            }
            
        }.resume()
    }
    
}
