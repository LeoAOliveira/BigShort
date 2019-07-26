//
//  ViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 11/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class StockData {
    
    var stocksArray: [String]
    
    init(stocksSelection: [String]) {
        stocksArray = stocksSelection
        alphaVantageFetch()
    }
    

    struct Stocks{
        
        let price: String
        let change: String
        let changePercent: String
        
        init(json: [String: Any]) {
            
            if let globalQuote = json["Global Quote"] as? [String: Any]{
                
                price = globalQuote["05. price"] as? String ?? "ERRO1"
                change = globalQuote["09. change"] as? String ?? "ERRO2"
                changePercent = globalQuote["10. change percent"] as? String ?? "ERRO3"
                
            } else{
                price = "ERRO 11"
                change = "ERRO 22"
                changePercent = "ERRO 33"
            }
            
//            if let timeSeries = json["Time Series (Daily)"] as? [String: Any]{
//
//                let dateCurrent = Date()
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                let dateString = dateFormatter.string(from: dateCurrent)
//
//                if let day = timeSeries["\(dateString)"] as? [String: Any]{
//
//                    open = day["1. open"] as? String ?? "ERRO2"
//                    close = day["4. close"] as? String ?? "ERRO3"
//                    dividendAmount = day["7. dividend amount"] as? String ?? "ERRO4"
//
//                } else{
//                    open = "ERRO22"
//                    close = "ERRO33"
//                    dividendAmount = "ERRO44"
//                }
//
//            } else{
//                open = "ERRO22"
//                close = "ERRO33"
//                dividendAmount = "ERRO44"
//            }
        }
        
    }
    

    func alphaVantageFetch(){
        
        let apiKey = "COR1E5U5AX51SRR7"
        
        let stockString = "ABEV3"
        
        let urlString = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(stockString).SA&apikey=\(apiKey)"
        
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

