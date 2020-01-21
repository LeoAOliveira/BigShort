//
//  StocksTableViewDataSource.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 17/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit

class StocksTableViewDataSource: NSObject, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    weak var stocksViewController: StocksViewController?
    
    init(viewController: StocksViewController) {
        stocksViewController = viewController
    }
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let stocksVC = stocksViewController else {
            return UITableViewCell()
        }
        
        // Position Card
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "positionCell", for: indexPath) as! PositionCell
            
            cell.marketLabel.text = stocksVC.marketLabel
            cell.marketView.backgroundColor = stocksVC.marketColor
            cell.marketView.layer.cornerRadius = cell.marketView.frame.size.width/2
            cell.marketView.clipsToBounds = true
            
            cell.positionView.layer.cornerRadius = 10.0
            
            cell.titleLabel.text = "Posição"
            cell.balanceLabel.text = "Saldo disponível: \(MathOperations.currencyFormatter(value: stocksVC.data1[0].availableBalance))"
            
            var incomeValue = 0.0
            
            if stocksVC.stockList.count == 0 {
                cell.totalValueLabel.text = MathOperations.currencyFormatter(value: 0.0)
                cell.investedValueLabel.text = "Valor investido: \(MathOperations.currencyFormatter(value: 0.0))"
            
            } else {
                cell.totalValueLabel.text = MathOperations.currencyFormatter(value: stocksCurrentPrice())
                
                incomeValue = Double(MathOperations.calculateIncome(value1: stocksCurrentPrice(), value2: investedValue()))
                cell.investedValueLabel.text = "Valor investido: \(MathOperations.currencyFormatter(value: investedValue()))"
            }
            
            if incomeValue > 0 {
                
                cell.incomeLabel.text = "Rendimento: "
                cell.incomeValueLabel.text = "+ \(MathOperations.currencyFormatter(value: Float(incomeValue)))"
                cell.incomeValueLabel.textColor = #colorLiteral(red: 0.1176470588, green: 0.6901960784, blue: 0.2549019608, alpha: 1)
            
            } else if incomeValue < 0 {
                
                cell.incomeLabel.text = "Prejuízo: "
                cell.incomeValueLabel.text = "- \(MathOperations.currencyFormatter(value: Float(incomeValue) * -1.0))"
                cell.incomeValueLabel.textColor = #colorLiteral(red: 0.7098039216, green: 0.1647058824, blue: 0.1647058824, alpha: 1)
            
            } else{
                cell.incomeLabel.text = "Rendimento: "
                cell.incomeValueLabel.text = MathOperations.currencyFormatter(value: Float(incomeValue))
                cell.incomeValueLabel.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
            }
            
            return cell
            
            
        // Stocks Card
        } else if indexPath.row == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "stocksCell", for: indexPath) as! StockCell
            
            cell.stocksView.layer.cornerRadius = 10.0
            
            cell.titleLabel.text = "Meus ativos"
            
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            
            cell.lastUpdateLabel.text = "Última atualização: \(MathOperations.formatDate(data: stocksVC.data1))"
            
            if stocksVC.stockList.count > 2{
                cell.sourceLabel.text = "Dados fornecidos por World Trading Data"
                
                if stocksVC.hasYDUQ3 == true{
                    cell.sourceLabel.text = "Dados de Alpha Vantage & World Trading Data"
                }
            
            } else {
                cell.sourceLabel.text = "Dados fornecidos por Alpha Vantage"
                
            }
            
            cell.collectionView.reloadData()
            
            return cell
            
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "investmentsCell", for: indexPath) as! InvestmentsCell
            
            cell.titleLabel.text = ""
            cell.valueLabel.text = ""
            cell.descriptionLabel.text = ""
            
            return cell
        }
    }
    
    func stocksCurrentPrice() -> Float {
        
        guard let stocksVC = stocksViewController else {
            return 0.0
        }
        
        return MathOperations.stocksCurrentPrice(stockList: stocksVC.stockList, data: stocksVC.data2, index: stocksVC.index)
    }
    
    func investedValue() -> Float {
        
        guard let stocksVC = stocksViewController else {
            return 0.0
        }
        
        return MathOperations.investedValue(stockList: stocksVC.stockList, data: stocksVC.data2, index: stocksVC.index)
    }
    
    // MARK: - CollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let stocksVC = stocksViewController else {
            return 0
        }
        
        return stocksVC.stockList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let stocksVC = stocksViewController else {
            return UICollectionViewCell()
        }
        
        if indexPath.row != stocksVC.stockList.count{
            
            let cellCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "stockCollectionCell", for: indexPath) as! StockCollectionViewCell
            
            cellCollection.stockView.layer.cornerRadius = 10.0
            cellCollection.symbolLabel.text = stocksVC.data2[stocksVC.index[indexPath.row]].symbol
            
            let change = stocksVC.data2[stocksVC.index[indexPath.row]].change
            
            if stocksVC.data2[stocksVC.index[indexPath.row]].change < 0{
                cellCollection.changePercentageLabel.textColor = #colorLiteral(red: 0.7725490196, green: 0.06274509804, blue: 0.1254901961, alpha: 1)
                cellCollection.changePercentageLabel.text = "\(String(format: "%.2f", change))%"
                
            } else if stocksVC.data2[stocksVC.index[indexPath.row]].change > 0{
                cellCollection.changePercentageLabel.textColor = #colorLiteral(red: 0.1176470588, green: 0.6901960784, blue: 0.2549019608, alpha: 1)
                cellCollection.changePercentageLabel.text = "+\(String(format: "%.2f", change))%"
                
            } else{
                cellCollection.changePercentageLabel.text = "\(String(format: "%.2f", change))%"
                cellCollection.changePercentageLabel.textColor = #colorLiteral(red: 0.9408631921, green: 0.9652459025, blue: 0.9907889962, alpha: 1)
            }
            
            cellCollection.priceLabel.text = MathOperations.currencyFormatter(value: stocksVC.data2[stocksVC.index[indexPath.row]].price)
            
                return cellCollection
        
        } else{
            
            let cellCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "addCollectionCell", for: indexPath) as! AddCollectionViewCell
            
            return cellCollection
            
        }
    }
    
    // MARK: - CollectionView Delegate
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let stocksVC = stocksViewController else {
            return
        }
        
        if indexPath.row <= stocksVC.stockList.count-1{
            stocksVC.selectedIndex = stocksVC.index[indexPath.row]
            stocksVC.selectedStock = stocksVC.data2[stocksVC.index[indexPath.row]].symbol!
            
            stocksVC.performSegue(withIdentifier: "detailStockSegue", sender: self)
        
        } else{
            
            if stocksVC.stockList.count >= 5{
                
                stocksVC.createAlert(title: "Limite de ações atingido", message: "Você pode possuir no máximo 5 ações diferentes.", actionTitle: "OK")
                
            } else{
                
                verifyMarket(purpose: "buyAndSell")
            }
        }
    }
    
    func verifyMarket(purpose: String){
        
        guard let stocksVC = stocksViewController else {
            return
        }
        
        let marketStatus = MarketManager.verifyMarket(purpose: purpose)
        
        if marketStatus == "Market closed alert" {
            stocksVC.createAlert(title: "Mercado fechado", message: "Operações só podem ser realizadas em dias úteis.", actionTitle: "OK")
            
        } else if marketStatus == "Operations avilable" {
            stocksVC.performSegue(withIdentifier: "addStockSegue", sender: self)
            
        } else {
            print("Error at market verification")
        }
    }
    
}
