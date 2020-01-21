//
//  MathFunctions.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 16/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import Foundation

public class MathOperations: NSObject {
    
    static func currencyFormatter(value: Float) -> String{
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "pt_BR")
        
        guard let valueString = currencyFormatter.string(from: NSNumber(value: value)) else {
            return "Error"
        }
        
        return valueString
    }
    
    static func calculateChange(value1: Float, value2: Float) -> Float{
        
        let change: Float = ((value2 - value1) / value1) * 100.0
        
        return change
    }
    
    static func calculateIncome(value1: Float, value2: Float) -> Float{
        
        let income: Float = value1 - value2
        
        return income
    }
    
    static func formatDate(data: [Wallet]) -> String{
        
        let lastUpdate = data[0].lastUpdate!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        dateFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        
        return dateFormatter.string(from: lastUpdate)
    }
    
    static func stocksCurrentPrice(stockList: [String], data: [Stock], index: [Int]) -> Float{
        
        var allStocks: Float = 0.0
        
        if stockList.count != 0 {
            for i in 0...stockList.count-1 {
                allStocks += data[index[i]].price * data[index[i]].amount
            }
        }
        
        return allStocks
    }
    
    static func stocksPriceClose(stockList: [String], data: [Stock], index: [Int]) -> Float{
        
        var allStocks: Float = 0.0
        
        for i in 0...(stockList.count-1){
            allStocks += data[index[i]].close
        }
        
        return allStocks
    }
    
    static func investedValue(stockList: [String], data: [Stock], index: [Int]) -> Float{
        
        var allStocks: Float = 0.0
        
        if stockList.count != 0 {
            for i in 0...stockList.count-1{
                allStocks += data[index[i]].invested
            }
        }
        
        return allStocks
        
    }
    
}
