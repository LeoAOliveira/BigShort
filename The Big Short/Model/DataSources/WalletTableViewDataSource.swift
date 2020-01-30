//
//  WalletTableViewDataSource.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 27/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import Foundation
import UIKit

class WalletTableViewDataSource: NSObject, UITableViewDataSource {
    
    weak var walletViewController: WalletViewController?
    
    var currencyArray = [String]()
    var stockArray = [String]()
    
    init(viewController: WalletViewController) {
        walletViewController = viewController
    }
    
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        guard let walletVC = walletViewController else {
            return 2
        }
        
        // Todos
        if walletVC.segmented.selectedSegmentIndex == 0 {
            
            let totalInvestment: Float = stocksCurrentPrice() + currenciesCurrentPrice()
            
            if totalInvestment > 0 {
                return 3
            }
        
        // Ações
        } else if walletVC.segmented.selectedSegmentIndex == 1 {
            
            if let stocks = walletVC.data1[0].stockList {
                let stocksArray = stocks.components(separatedBy: ":")
                self.stockArray = stocksArray
                return (2 + stocksArray.count)
            }
        
        // Moedas
        } else {
            
            if let currencies = walletVC.data1[0].currencyList {
                let currenciesArray = currencies.components(separatedBy: ":")
                self.currencyArray = currenciesArray
                return (2 + currenciesArray.count)
            }
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let walletVC = walletViewController else {
            return UITableViewCell()
        }
        
        // MARK: - Investment Header
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myInvestmentsCell", for: indexPath) as! InvestmentsCell
            
            var incomeValue = 0.0
            
            // Todos
            if walletVC.segmented.selectedSegmentIndex == 0 {
                
                let totalInvestment: Float = stocksCurrentPrice() + currenciesCurrentPrice()
                let invested = investedStocksValue() + investedCurrencyValue()
                
                cell.titleLabel.text = "Meus investimentos"
                cell.valueLabel.text = MathOperations.currencyFormatter(value: totalInvestment)
                incomeValue = Double(MathOperations.calculateIncome(value1: totalInvestment, value2: invested))
            
            // Ações
            } else if walletVC.segmented.selectedSegmentIndex == 1 {
                
                let totalInvestment: Float = stocksCurrentPrice()
                
                cell.titleLabel.text = "Posição"
                cell.valueLabel.text = MathOperations.currencyFormatter(value: totalInvestment)
                incomeValue = Double(MathOperations.calculateIncome(value1: stocksCurrentPrice(), value2: investedStocksValue()))
            
            // Moedas
            } else {
                
                let totalInvestment: Float = currenciesCurrentPrice()
                
                cell.titleLabel.text = "Posição"
                cell.valueLabel.text = MathOperations.currencyFormatter(value: totalInvestment)
                incomeValue = Double(MathOperations.calculateIncome(value1: currenciesCurrentPrice(), value2: investedCurrencyValue()))
            }
            
            if incomeValue > 0 {
                cell.descriptionLabel.text = "+ \(MathOperations.currencyFormatter(value: Float(incomeValue)))"
                cell.descriptionLabel.textColor = #colorLiteral(red: 0.1176470588, green: 0.6901960784, blue: 0.2549019608, alpha: 1)
            
            } else if incomeValue < 0 {
                cell.descriptionLabel.text = "- \(MathOperations.currencyFormatter(value: Float(incomeValue) * -1.0))"
                cell.descriptionLabel.textColor = #colorLiteral(red: 0.7098039216, green: 0.1647058824, blue: 0.1647058824, alpha: 1)
            
            } else {
                cell.descriptionLabel.text = MathOperations.currencyFormatter(value: Float(incomeValue))
                cell.descriptionLabel.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
            }
            
            return cell
            
            
        // MARK: - Wallet Card
        } else if indexPath.row == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath) as! MenuCell
            
            // Todos
            if walletVC.segmented.selectedSegmentIndex == 0 {
            
                cell.titleLabel.text = "Carteira"
                
                let invested = investedStocksValue() + investedCurrencyValue()
                cell.description1Label.text = MathOperations.currencyFormatter(value: invested)
            
            // Ações
            } else if walletVC.segmented.selectedSegmentIndex == 1 {
            
                cell.titleLabel.text = "Ações"
                
                let invested = investedStocksValue()
                cell.description1Label.text = MathOperations.currencyFormatter(value: invested)
            
            // Moedas
            } else {
                
                cell.titleLabel.text = "Moedas"
                
                let invested = investedCurrencyValue()
                cell.description1Label.text = MathOperations.currencyFormatter(value: invested)
            }
            
            cell.description2Label.text = MathOperations.currencyFormatter(value: walletVC.data1[0].availableBalance)
            
            return cell
            
        // MARK: - Chart Card
        } else {
            
            // Todos
            if walletVC.segmented.selectedSegmentIndex == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectorCell", for: indexPath) as! ChartCell
                
                let totalInvestment: Float = stocksCurrentPrice() + currenciesCurrentPrice()
                
                let stocks: Float = ((100 * stocksCurrentPrice()) / totalInvestment) / 100
                
                cell.sectorChart.firstValue = CGFloat(stocks)
                cell.color1.layer.cornerRadius = 7.0
                cell.color2.layer.cornerRadius = 7.0
                
                return cell
            
            // Ações
            } else if walletVC.segmented.selectedSegmentIndex == 1 {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "barCell", for: indexPath) as! ChartCell
                
                cell.description1Label.text = stockArray[indexPath.row-2]
                
                let index = walletVC.stockIndex[indexPath.row-2]
                let position = walletVC.data2[index].price * walletVC.data2[index].amount
                
                let stock: Float = ((100 * position) / stocksCurrentPrice()) / 100
                
                cell.barChart.valueWidth = CGFloat(stock)
                
                return cell
            
            // Moedas
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "barCell", for: indexPath) as! ChartCell
                
                cell.description1Label.text = currencyArray[indexPath.row-2]
                
                let index = walletVC.currencyIndex[indexPath.row-2]
                let position = walletVC.data4[index].investedBRL
                
                let currency: Float = ((100 * position) / currenciesCurrentPrice()) / 100
                
                cell.barChart.valueWidth = CGFloat(currency)
                
                return cell
            }
            
        }
    }
    
    // MARK: - Math Operations
    func stocksCurrentPrice() -> Float {
        
        guard let walletVC = walletViewController else {
            return 0.0
        }
        
        return MathOperations.stocksCurrentPrice(stockList: walletVC.stockList, data: walletVC.data2, index: walletVC.stockIndex)
    }
    
    func investedStocksValue() -> Float {
        
        guard let walletVC = walletViewController else {
            return 0.0
        }
        
        return MathOperations.investedValue(stockList: walletVC.stockList, data: walletVC.data2, index: walletVC.stockIndex)
    }
    
    func currenciesCurrentPrice() -> Float {
        
        guard let walletVC = walletViewController else {
            return 0.0
        }
        
        return MathOperations.currenciesCurrentPrice(currencyList: walletVC.currencyList, data: walletVC.data4, index: walletVC.currencyIndex)
    }

    func investedCurrencyValue() -> Float {
        
        guard let walletVC = walletViewController else {
            return 0.0
        }
        
        return MathOperations.currenciesInvestedValue(currencyList: walletVC.currencyList, data: walletVC.data4, index: walletVC.currencyIndex)
    }
    
}
