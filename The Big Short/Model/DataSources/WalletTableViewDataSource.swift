//
//  WalletTableViewDataSource.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 27/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import Foundation
import UIKit
import CareKitUI

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
            
            // All
            if walletVC.segmented.selectedSegmentIndex == 0 {
                
                let totalInvestment: Float = stocksCurrentPrice() + currenciesCurrentPrice()
                let invested = investedStocksValue() + investedCurrencyValue()
                
                cell.titleLabel.text = "Meus investimentos"
                cell.valueLabel.text = MathOperations.currencyFormatter(value: totalInvestment)
                incomeValue = Double(MathOperations.calculateIncome(value1: totalInvestment, value2: invested))
            
            // Stocks
            } else if walletVC.segmented.selectedSegmentIndex == 1 {
                
                let totalInvestment: Float = stocksCurrentPrice()
                
                cell.titleLabel.text = "Posição"
                cell.valueLabel.text = MathOperations.currencyFormatter(value: totalInvestment)
                incomeValue = Double(MathOperations.calculateIncome(value1: stocksCurrentPrice(), value2: investedStocksValue()))
            
            // Currencies
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
            
            // All
            if walletVC.segmented.selectedSegmentIndex == 0 {
            
                cell.titleLabel.text = "Carteira"
                
                let invested = investedStocksValue() + investedCurrencyValue()
                cell.description1Label.text = MathOperations.currencyFormatter(value: invested)
            
            // Stocks
            } else if walletVC.segmented.selectedSegmentIndex == 1 {
            
                cell.titleLabel.text = "Ações"
                
                let invested = investedStocksValue()
                cell.description1Label.text = MathOperations.currencyFormatter(value: invested)
            
            // Currencies
            } else {
                
                cell.titleLabel.text = "Moedas"
                
                let invested = investedCurrencyValue()
                cell.description1Label.text = MathOperations.currencyFormatter(value: invested)
            }
            
            cell.description2Label.text = MathOperations.currencyFormatter(value: walletVC.data1[0].availableBalance)
            
            return cell
            
        // MARK: - Chart Card
        } else {
            
            // All
            if walletVC.segmented.selectedSegmentIndex == 0 {
                
//                let cell = tableView.dequeueReusableCell(withIdentifier: "sectorCell", for: indexPath) as! ChartCell
//                
//                let totalInvestment: Float = stocksCurrentPrice() + currenciesCurrentPrice()
//                
//                let stocks: Float = ((100 * stocksCurrentPrice()) / totalInvestment) / 100
//                
//                cell.sectorChart.firstValue = CGFloat(stocks)
//                cell.color1.layer.cornerRadius = 7.0
//                cell.color2.layer.cornerRadius = 7.0
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "chartCell", for: indexPath)
                
                let chartView = OCKCartesianChartView(type: .line)

                chartView.headerView.titleLabel.text = "Resultado de Semanal"
                chartView.headerView.detailLabel.text = "Desempenho em %"
                chartView.graphView.horizontalAxisMarkers = ["23", "24", "25", "26", "27"]

                var dataSeries1 = OCKDataSeries(values: [-5, -12, -3, 0, 5], 
                                                title: "Ações", 
                                                gradientStartColor: #colorLiteral(red: 0.4568741859, green: 0.606234932, blue: 0.869666085, alpha: 1), 
                                                gradientEndColor: #colorLiteral(red: 0.5317068696, green: 0.7064753175, blue: 0.9996883273, alpha: 1))
                
                var dataSeries2 = OCKDataSeries(values: [3, 10, 8, 4, 4], 
                                                title: "Moedas", 
                                                gradientStartColor: #colorLiteral(red: 1, green: 0.7709652185, blue: 0.2649626732, alpha: 1), 
                                                gradientEndColor: #colorLiteral(red: 0.9843137264, green: 0.850980401, blue: 0, alpha: 1))
                
                var dataSeries3 = OCKDataSeries(values: [-7, -10, -2, 7, 10], 
                                                title: "Ibovespa", 
                                                gradientStartColor: #colorLiteral(red: 0.8608239889, green: 0.0958115384, blue: 0.1982795596, alpha: 1), 
                                                gradientEndColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                
                dataSeries1.size = 2.5
                dataSeries2.size = 2.5
                dataSeries3.size = 2.5
                
                
                chartView.graphView.dataSeries = [dataSeries1, dataSeries2, dataSeries3]
                
                chartView.graphView.yMaximum = 20
                chartView.graphView.yMinimum = -20
                
//                chartView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1) 
//                
//                chartView.tintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1) 
//                
//                chartView.graphView.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) 
//                
//                chartView.graphView.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) 
//                
//                chartView.graphView.layer.backgroundColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1) 
//                
//                chartView.graphView.layer.borderColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1) 
//                
//                chartView.graphView.layer.shadowColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) 
//                
//                chartView.headerView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1) 
//                
//                chartView.headerView.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) 
//                
//                chartView.layer.cornerRadius = 0.0
//                chartView.layer.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) 
//                
                cell.contentView.addSubview(chartView)
                chartView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    chartView.leadingAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.leadingAnchor),
                    chartView.trailingAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.trailingAnchor),
                    chartView.topAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.topAnchor),
                    chartView.bottomAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.bottomAnchor)
                ])
                
                return cell
            
            // Stocks
            } else if walletVC.segmented.selectedSegmentIndex == 1 {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "barCell", for: indexPath) as! ChartCell
                
                cell.description1Label.text = stockArray[indexPath.row-2]
                
                let index = walletVC.stockIndex[indexPath.row-2]
                let position = walletVC.data2[index].price * walletVC.data2[index].amount
                
                let stock: Float = ((100 * position) / stocksCurrentPrice()) / 100
                
                cell.barChart.valueWidth = CGFloat(stock)
                
                return cell
            
            // Currencies
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
