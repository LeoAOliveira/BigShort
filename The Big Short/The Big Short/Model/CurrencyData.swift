//
//  CurrencyData.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 16/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import Foundation

class CurrencyData {
    
    
    struct Currency{
        
        let dollar: Int
        
        init(json: [String: Any]) {
            
            if let rates = json["rates"] as? [String: Any]{
                
                dollar = rates["USD"] as? Int ?? -1
                
            } else{
                dollar = -11
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
                    
                    let currency = Currency(json: json)
                    print(currency.dollar)
                    
                } catch let err{
                    print(err.localizedDescription)
                }
            }
            
            }.resume()
    }
}
