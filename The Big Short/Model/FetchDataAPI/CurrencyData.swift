//
//  CurrencyData.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 16/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData

class CurrencyData {
    
    var data1 = [Wallet]()
    var data4 = [Currency]()
    
    let dispatchGroup = DispatchGroup()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    struct Currencies {
        
        var exchange = [String: Float]()
        
        init(json: [String: Any]) {
            
            if let data = json["response"] as? [Dictionary<String,Any>] {
                
                for i in 0...47 {
                    
                    if let currency = data[i] as? [String: Any] {
                        
                        let symbol = currency["symbol"] as? String ?? "-1"
                        let price = currency["price"] as? String ?? "-1"
                        
                        exchange[symbol] = Float(price)
                    }
                }
                
            } else{
                
                let symbol = "-1"
                let price = "-1"
                
                exchange[symbol] = Float(price)
            }
        }
    }
    
    
    func exchangeRatesFetch(){
        
        let urlString = "https://fcsapi.com/api/forex/latest?id=297,298,299,301,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,323,324,327,328,329,331,333,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,356&access_key=JvVn0G72MS2Ab0WcprB68I2CUXOowawWEIcoTqHPFgf3scwFjw"
        
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
                    
                    let currency = Currencies(json: json)
                    
                    do {
                        self.data1 = try self.context.fetch(Wallet.fetchRequest())
                        self.data4 = try self.context.fetch(Currency.fetchRequest())
                        
                        let data1 = self.data1[0]
                        data1.lastUpdateCurrency = Date()
                        
                        let orderedExchange = currency.exchange.sorted(by: <)
                        var currencyArray: [Float] = []
                        
                        for (key,value) in orderedExchange {
                            currencyArray.append(value)
                        }
                        
                        for i in 0...47 {
                            
                            let price = Float(1.0) / Float(currencyArray[i])
                            let data4 = self.data4[i]
                            data4.price = Float(price)
                            
                            do {
                                try self.context.save()
                                
                            } catch{
                                print("Error when saving context (Currency)")
                            }
                        }
                        
                    } catch {
                        print("Erro ao inserir os dados de moedas")
                        print(error.localizedDescription)
                    }
                    
                } catch let err{
                    print(err.localizedDescription)
                }
            }
            
        }.resume()
    }
}
