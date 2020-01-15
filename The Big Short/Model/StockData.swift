//
//  ViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 11/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData

class StockData {
    
//    var stocksArray: [String]
//    var index: [Int]
    
    var resultsArray: [Array<String>] = []
    
    public var data1 = [Wallet]()
    public var data2 = [Stock]()
    
    let dispatchGroup = DispatchGroup()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    init(stocksSelection: [String], dataIndex: [Int]) {
//        stocksArray = stocksSelection
//        index = dataIndex
//        alphaVantageFetch()
//    }
    
    struct Stocks{
        
        let price: String
        let close: String
        let change: String
        let changePercent: String
        
        init(json: [String: Any]) {
            
            if let globalQuote = json["Global Quote"] as? [String: Any]{
                
                close = globalQuote["08. previous close"] as? String ?? "ERRO1"
                price = globalQuote["05. price"] as? String ?? "ERRO2"
                change = globalQuote["09. change"] as? String ?? "ERRO3"
                changePercent = globalQuote["10. change percent"] as? String ?? "ERRO4"
                
            } else{
                close = "ERRO 11"
                price = "ERRO 22"
                change = "ERRO 33"
                changePercent = "ERRO 44"
            }
        }
        
    }
    
    func downloadData(completion: @escaping () -> Void){
        
        let deadline = DispatchTime.now()
        
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    

    func alphaVantageFetch(stocksArray: [String], index: [Int], completion: @escaping (Bool) -> () ){
        
        let apiKey = "COR1E5U5AX51SRR7"
        
        for i in 0...stocksArray.count-1{
            
            let urlString = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(stocksArray[i]).SA&apikey=\(apiKey)"
            
            guard let url = URL(string: urlString) else{
                print("Erro 1")
                return
            }
//            dispatchGroup.notify(queue: .main) {
//                self.tableView.reloadData()
//            }
            
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
                        
//                        self.resultsArray[i].append(stock.open)
//                        self.resultsArray[i].append(stock.price)
//                        self.resultsArray[i].append(stock.changePercent)
                        
                        do {
                            
                            self.data1 = try self.context.fetch(Wallet.fetchRequest())
                            self.data2 = try self.context.fetch(Stock.fetchRequest())
                            
                            let data1 = self.data1[0]
                            data1.lastUpdate = Date()
                            
                            let data2 = self.data2[index[i]]
                            
                            if stock.close == "ERRO 11" || stock.price == "ERRO 22"{
                                
                                completion(false)
                                
                            } else{
                                data2.close = Float(stock.close)!
                                data2.price = Float(stock.price)!
                                
                                data2.change = ((data2.price - data2.close) / data2.close) * 100.0
                                
                                // data2.change = stock.changePercent
                                
                                do{
                                    try self.context.save()
                                    
                                } catch{
                                    print("Error when saving context (MSD)")
                                    completion(false)
                                }
                                
                                completion(true)
                            }
                            
                        } catch {
                            print("Erro ao inserir os dados de ações")
                            print(error.localizedDescription)
                            completion(false)
                        }
                        
                        // Array: [0] = open ; [1] = price ; [2] = changePercent
                        
                    } catch let err{
                        print(err.localizedDescription)
                    }
                }
                    
            }.resume()
        }
        
//        dispatchGroup.notify(queue: .main) {
//            return self.resultsArray
//        }
//
//        // return resultsArray
    }
    
    
/*
    func bloombergDataFetch(){
        
        // let bloombergURL = "https://www.bloomberg.com/quote/IBOV:IND/members"
        
        let bloombergURL = URL(string: "https://www.bloomberg.com/quote/IBOV:IND/members")!
        
        let task = URLSession.shared.dataTask(with: bloombergURL) { (data, response, error) in
            
            guard let data = data else{
                print("data was nil")
                return
            }
            
            guard let htmlString = String(data: data, encoding: String.Encoding.utf8) else{
                print("cannot cast data into string")
                return
            }
            
            // print(htmlString)
            
            let leftSideOfTheValue = """
<a class="security-summary__ticker" href="/quote/ABEV3:BZ">ABEV3:BZ</a><div class="security-summary__head-row-details">  <div class="security-summary__price">
"""
            
            let rightSideOfTheValue = """
</div>  <div class="security-summary__price-change">
"""
            
            guard let leftRange = htmlString.range(of: leftSideOfTheValue) else{
                print("Error left")
                return
            }
            
            guard let rightRange = htmlString.range(of: rightSideOfTheValue) else{
                print("Error right")
                return
            }
            
            let rangeOfTheValue = leftRange.upperBound..<rightRange.lowerBound
            
            print(htmlString[rangeOfTheValue])
        }
        
        task.resume()
    }
    
    
    func b3DataFetch(symbol: String){
        
        let b3URL = URL(string: "http://www.b3.com.br/pt_br/market-data-e-indices/servicos-de-dados/market-data/cotacoes/?tvwidgetsymbol=\(symbol)")!
        
        let task = URLSession.shared.dataTask(with: b3URL) { (data, response, error) in
            
            guard let data = data else{
                print("data was nil")
                return
            }
            
            guard let htmlString = String(data: data, encoding: String.Encoding.utf8) else{
                print("cannot cast data into string")
                return
            }
            
            // print(htmlString)
            
//            let leftSideOfTheValue = """
//"""
//
//            let rightSideOfTheValue = """""
//"""
//
//            guard let leftRange = htmlString.range(of: leftSideOfTheValue) else{
//                print("Error left")
//                return
//            }
//
//            guard let rightRange = htmlString.range(of: rightSideOfTheValue) else{
//                print("Error right")
//                return
//            }
//
//            let rangeOfTheValue = leftRange.upperBound..<rightRange.lowerBound
//
//            print(htmlString[rangeOfTheValue])
        }
        
        task.resume()
    }
*/
    
    

}

