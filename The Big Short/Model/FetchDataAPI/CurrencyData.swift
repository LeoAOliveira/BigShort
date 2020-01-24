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
        
        var exchange: [Double] = []
        
        init(json: [String: Any]) {
            
            if let rates = json["rates"] as? [String: Any]{
                
                exchange.append(rates["AUD"] as? Double ?? -1.0)
                exchange.append(rates["BGN"] as? Double ?? -1.0)
                exchange.append(rates["CAD"] as? Double ?? -1.0)
                exchange.append(rates["CHF"] as? Double ?? -1.0)
                exchange.append(rates["CNY"] as? Double ?? -1.0)
                exchange.append(rates["CZK"] as? Double ?? -1.0)
                exchange.append(rates["DKK"] as? Double ?? -1.0)
                exchange.append(rates["EUR"] as? Double ?? -1.0)
                exchange.append(rates["GBP"] as? Double ?? -1.0)
                exchange.append(rates["HKD"] as? Double ?? -1.0)
                exchange.append(rates["HRK"] as? Double ?? -1.0)
                exchange.append(rates["HUF"] as? Double ?? -1.0)
                exchange.append(rates["IDR"] as? Double ?? -1.0)
                exchange.append(rates["ILS"] as? Double ?? -1.0)
                exchange.append(rates["INR"] as? Double ?? -1.0)
                exchange.append(rates["ISK"] as? Double ?? -1.0)
                exchange.append(rates["JPY"] as? Double ?? -1.0)
                exchange.append(rates["KRW"] as? Double ?? -1.0)
                exchange.append(rates["MXN"] as? Double ?? -1.0)
                exchange.append(rates["MYR"] as? Double ?? -1.0)
                exchange.append(rates["NOK"] as? Double ?? -1.0)
                exchange.append(rates["NZD"] as? Double ?? -1.0)
                exchange.append(rates["PHP"] as? Double ?? -1.0)
                exchange.append(rates["PLN"] as? Double ?? -1.0)
                exchange.append(rates["RON"] as? Double ?? -1.0)
                exchange.append(rates["RUB"] as? Double ?? -1.0)
                exchange.append(rates["SEK"] as? Double ?? -1.0)
                exchange.append(rates["SGD"] as? Double ?? -1.0)
                exchange.append(rates["THB"] as? Double ?? -1.0)
                exchange.append(rates["TRY"] as? Double ?? -1.0)
                exchange.append(rates["USD"] as? Double ?? -1.0)
                exchange.append(rates["ZAR"] as? Double ?? -1.0)
                
            } else{
                exchange.append(-11.0)
            }
        }
    }
    
    
    func exchangeRatesFetch(){
        
        let urlString = "https://api.exchangeratesapi.io/latest?base=BRL"
        
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
                        
                        for i in 0...31 {
                            
                            let data4 = self.data4[i]
                            data4.proportion = Float(currency.exchange[i])
                            
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
