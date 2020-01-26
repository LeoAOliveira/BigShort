//
//  MainTableViewDataSource.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 20/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import Foundation
import UIKit

class MainTableViewDataSource: NSObject, UITableViewDataSource {
    
    weak var mainViewController: MainViewController?
    
    init(viewController: MainViewController) {
        mainViewController = viewController
    }
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let mainVC = mainViewController else {
            return UITableViewCell()
        }
        
        // MARK: - Investment Header
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myInvestmentsCell", for: indexPath) as! InvestmentsCell
            
            let totalInvestment: Float = stocksCurrentPrice() + currenciesCurrentPrice()
            
            var incomeValue = 0.0
            
            cell.valueLabel.text = MathOperations.currencyFormatter(value: totalInvestment)
            incomeValue = Double(MathOperations.calculateIncome(value1: stocksCurrentPrice(), value2: investedValue()))
            
            incomeValue = Double(MathOperations.calculateIncome(value1: stocksCurrentPrice(), value2: investedValue()))
            
            if incomeValue > 0 {
                cell.descriptionLabel.text = "+ \(MathOperations.currencyFormatter(value: Float(incomeValue)))"
                cell.descriptionLabel.textColor = #colorLiteral(red: 0.1176470588, green: 0.6901960784, blue: 0.2549019608, alpha: 1)
            
            } else if incomeValue < 0 {
                cell.descriptionLabel.text = "- \(MathOperations.currencyFormatter(value: Float(incomeValue) * -1.0))"
                cell.descriptionLabel.textColor = #colorLiteral(red: 0.7098039216, green: 0.1647058824, blue: 0.1647058824, alpha: 1)
            
            } else{
                cell.descriptionLabel.text = MathOperations.currencyFormatter(value: Float(incomeValue))
                cell.descriptionLabel.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
            }
            
            return cell
            
            
        // MARK: - Stocks Card
        } else if indexPath.row == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
            
            cell.titleLabel.text = "Ações"
            
            var incomeValue = 0.0
            
            if mainVC.stockList.count == 0 {
                cell.totalValueLabel.text = MathOperations.currencyFormatter(value: 0.0)
            
            } else {
                cell.totalValueLabel.text = MathOperations.currencyFormatter(value: stocksCurrentPrice())
                incomeValue = Double(MathOperations.calculateIncome(value1: stocksCurrentPrice(), value2: investedValue()))
            }
            
            cell.subtitle1Label.text = "Minhas ações hoje: "
            
            if incomeValue > 0 {
                cell.description1Label.text = "+ \(MathOperations.currencyFormatter(value: Float(incomeValue)))"
                cell.description1Label.textColor = #colorLiteral(red: 0.1176470588, green: 0.6901960784, blue: 0.2549019608, alpha: 1)

            } else if incomeValue < 0 {
                cell.description1Label.text = "- \(MathOperations.currencyFormatter(value: Float(incomeValue) * -1.0))"
                cell.description1Label.textColor = #colorLiteral(red: 0.7098039216, green: 0.1647058824, blue: 0.1647058824, alpha: 1)

            } else{
                cell.description1Label.text = MathOperations.currencyFormatter(value: Float(incomeValue))
                cell.description1Label.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
            }
            
            return cell
            
        // MARK: - Currency Card
        } else if indexPath.row == 2 {
                    
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
            
            cell.titleLabel.text = "Moedas"
            
            var incomeValue = 0.0
            
            let currencies = mainVC.data1[0].currencyList
            
            let currencyArray = currencies?.components(separatedBy: ":")
            
            if currencyArray?.count == 0 || currencyArray?.count == nil {
                cell.totalValueLabel.text = MathOperations.currencyFormatter(value: 0.0)
            
            } else {
                cell.totalValueLabel.text = MathOperations.currencyFormatter(value: currenciesCurrentPrice())
                incomeValue = Double(MathOperations.calculateIncome(value1: currenciesCurrentPrice(), value2: investedCurrencyValue()))
            }
            
            cell.subtitle1Label.text = "Minhas moedas hoje: "
            
            if incomeValue > 0 {
                cell.description1Label.text = "+ \(MathOperations.currencyFormatter(value: Float(incomeValue)))"
                cell.description1Label.textColor = #colorLiteral(red: 0.1176470588, green: 0.6901960784, blue: 0.2549019608, alpha: 1)

            } else if incomeValue < 0 {
                cell.description1Label.text = "- \(MathOperations.currencyFormatter(value: Float(incomeValue) * -1.0))"
                cell.description1Label.textColor = #colorLiteral(red: 0.7098039216, green: 0.1647058824, blue: 0.1647058824, alpha: 1)

            } else{
                cell.description1Label.text = MathOperations.currencyFormatter(value: Float(incomeValue))
                cell.description1Label.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myInvestmentsCell", for: indexPath) as! InvestmentsCell
            
            cell.titleLabel.text = ""
            cell.valueLabel.text = ""
            cell.descriptionLabel.text = ""
            
            return cell
        }
    }
    
    func stocksCurrentPrice() -> Float {
        
        guard let mainVC = mainViewController else {
            return 0.0
        }
        
        return MathOperations.stocksCurrentPrice(stockList: mainVC.stockList, data: mainVC.data2, index: mainVC.stockIndex)
    }
    
    func investedValue() -> Float {
        
        guard let mainVC = mainViewController else {
            return 0.0
        }
        
        return MathOperations.investedValue(stockList: mainVC.stockList, data: mainVC.data2, index: mainVC.stockIndex)
    }
    
    func currenciesCurrentPrice() -> Float {
        
        guard let mainVC = mainViewController else {
            return 0.0
        }
        
//        let currencies = mainVC.data1[0].currencyList ?? ""
//
//        let currencyArray = currencies.components(separatedBy: ":")
//
//        let indexArray = findIndexesIn(currencyArray: currencyArray)
        
        return MathOperations.currenciesCurrentPrice(currencyList: mainVC.currencyList, data: mainVC.data4, index: mainVC.currencyIndex)
    }

    func investedCurrencyValue() -> Float {
        
        guard let mainVC = mainViewController else {
            return 0.0
        }
        
        return MathOperations.currenciesInvestedValue(currencyList: mainVC.currencyList, data: mainVC.data4, index: mainVC.currencyIndex)
    }
    
//    func findIndexesIn(currencyArray: [String]) -> [Int] {
//
//        var indexArray: [Int] = []
//
//        guard let mainVC = mainViewController else {
//            return indexArray
//        }
//
//        if currencyArray.count > 0 {
//
//            for i in 0...currencyArray.count-1 {
//
//                for n in 0...47 {
//
//                    if mainVC.data4[n].symbol == currencyArray[i] {
//                        indexArray.append(n)
//                    }
//                }
//            }
//        }
//        
//        mainVC.currencyIndex = indexArray
//        
//        return indexArray
//    }
    
}
