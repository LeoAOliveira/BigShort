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
    
    static func formatDate(lastUpdate: Date) -> String{
        
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
    
    static func investedValue(stockList: [String], data: [Stock], index: [Int]) -> Float{
        
        var allStocks: Float = 0.0
        
        if stockList.count != 0 {
            for i in 0...stockList.count-1{
                allStocks += data[index[i]].invested
            }
        }
        
        return allStocks
        
    }
    
    static func currenciesCurrentPrice(currencyList: [String], data: [Currency], index: [Int]) -> Float {
        
        var allCurrencies: Float = 0.0
        
        if currencyList.count != 0 && index.count != 0 {
            for i in 0...currencyList.count-1 {
                
                let convertedValue = Float(data[index[i]].invested * data[index[i]].price)
                
                allCurrencies += convertedValue
            }
        }
        
        return allCurrencies
    }
    
    static func currenciesInvestedValue(currencyList: [String], data: [Currency], index: [Int]) -> Float {
        
        var allCurrencies: Float = 0.0
        
        if currencyList.count != 0 {
            for i in 0...currencyList.count-1 {
                
                allCurrencies += Float(data[index[i]].investedBRL)
            }
        }
        
        return allCurrencies
    }
    
    static func brlValue(currencyValue: Float, rate: Float) -> Float{
        
        let newValue = Float(currencyValue / rate)
        
        return newValue
    }
    
    
    
}
