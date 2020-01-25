//
//  CurrenciesTableViewDataSource.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 22/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit

class CurrenciesTableViewDataSource: NSObject, UITableViewDataSource {

    weak var currenciesViewController: CurrenciesViewController?
    
    var currencyArray = [String]()
    
    init(viewController: CurrenciesViewController) {
        currenciesViewController = viewController
    }
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        guard let currenciesVC = currenciesViewController else {
            return 1
        }
        
        guard let currencies = currenciesVC.data1[0].currencyList else {
            return 1
        }
        
        let currenciesArray = currencies.components(separatedBy: ":")
        
        self.currencyArray = currenciesArray

        return (2 + currenciesArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let currenciesVC = currenciesViewController else {
            return UITableViewCell()
        }
        
        let indexArray = findIndexesInCurrencyArray()
        
        // MARK: - Investment Header
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myInvestmentsCell", for: indexPath) as! InvestmentsCell
            
            let totalInvestment: Float = currenciesCurrentPrice()
            
            var incomeValue = 0.0
            
            if currenciesVC.currencyList.count == 0 {
                cell.valueLabel.text = MathOperations.currencyFormatter(value: 0.0)
            
            } else {
                cell.valueLabel.text = MathOperations.currencyFormatter(value: totalInvestment)
                incomeValue = Double(MathOperations.calculateIncome(value1: currenciesCurrentPrice(), value2: investedValue()))
            }
            
            incomeValue = Double(MathOperations.calculateIncome(value1: currenciesCurrentPrice(), value2: investedValue()))
            
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
            
            
        // MARK: - Currencies Cards
        } else if indexPath.row == currencyArray.count+1 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell", for: indexPath) as! SimpleCell
            
            guard let date = currenciesVC.data1[0].lastUpdateCurrency else {
                return UITableViewCell()
            }
            
            cell.titleLabel.text = "Última atualização: \(MathOperations.formatDate(lastUpdate: date))"
            
            return cell
            
        } else {
            
            if currencyArray.count > 0 {
                
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyCell
            
            cell.currencyView.layer.cornerRadius = 10.0
            cell.currencySubview.layer.cornerRadius = 10.0
            
            let index = indexArray[indexPath.row-1]
            
            guard let symbol = currenciesVC.data4[index].symbol else {
                return cell
            }
            
            guard let name = currenciesVC.data4[index].name else {
                return cell
            }
            
            let invested = Float(currenciesVC.data4[index].invested)
            let investedBRL = Float(currenciesVC.data4[index].investedBRL)
            let price = Float(currenciesVC.data4[index].price)
            let mediumValue = Float(currenciesVC.data4[index].mediumPrice)
            
            let value = MathOperations.currencyFormatter(value: Float(invested*price))
            let currencyValue = MathOperations.currencyFormatter(value: Float(investedBRL))
            let priceCurrency = MathOperations.currencyFormatter(value: Float(price))
            let mediumPrice = MathOperations.currencyFormatter(value: Float(mediumValue))
            let change = MathOperations.calculateChange(value1: investedBRL, value2: invested*price)
            
            cell.titleLabel.text = "\(symbol) (\(name))"
            cell.valueLabel.text = value
            cell.currencyValueLabel.text = "\(symbol) \(String(format: "%.2f", invested))"
            cell.iconImage.image = UIImage(named: "\(symbol).png")
            cell.priceValueLabel.text = priceCurrency
            cell.mediumValueLabel.text = mediumPrice
            
            if change > 0.0{
                cell.variationValueLabel.textColor = #colorLiteral(red: 0, green: 0.7020406723, blue: 0.1667427123, alpha: 1)
                cell.variationValueLabel.text = "+\(String(format: "%.2f", change))%"
                
            } else if change < 0.0{
                cell.variationValueLabel.textColor = #colorLiteral(red: 0.7722620368, green: 0.0615144521, blue: 0.1260437667, alpha: 1)
                cell.variationValueLabel.text = "\(String(format: "%.2f", change))%"
                
            } else{
                cell.variationValueLabel.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
                cell.variationValueLabel.text = "\(String(format: "%.2f", change))%"
            }
            
            return cell
            
            
        }
    }
    
    func currenciesCurrentPrice() -> Float {
        
        guard let currenciesVC = currenciesViewController else {
            return 0.0
        }
        
        return MathOperations.currenciesCurrentPrice(currencyList: currenciesVC.currencyList, data: currenciesVC.data4, index: currenciesVC.currencyIndex)
    }
    
    func investedValue() -> Float {
        
        guard let currenciesVC = currenciesViewController else {
            return 0.0
        }
        
        return MathOperations.currenciesInvestedValue(currencyList: currenciesVC.currencyList, data: currenciesVC.data4, index: currenciesVC.currencyIndex)
    }
    
    func findIndexesInCurrencyArray() -> [Int] {
        
        var indexArray: [Int] = []
        
        guard let currenciesVC = currenciesViewController else {
            return indexArray
        }
        
        if currencyArray.count > 0 {
            
            for i in 0...currencyArray.count-1 {
                
                for n in 0...47 {
                    
                    if currenciesVC.data4[n].symbol == currencyArray[i] {
                        indexArray.append(n)
                    }
                }
            }
        }
        
        currenciesVC.currencyIndex = indexArray
        
        return indexArray
    }
    
}
