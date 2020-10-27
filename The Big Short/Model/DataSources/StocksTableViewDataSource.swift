//
//  StocksTableViewDataSource.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 17/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import Foundation
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let stocksVC = stocksViewController else {
            return UITableViewCell()
        }
        
        // MARK: - Position Card
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "positionCell", for: indexPath) as! InvestmentsCell
            
            cell.marketLabel.text = stocksVC.marketLabel
            cell.marketView.backgroundColor = stocksVC.marketColor
            cell.marketView.layer.cornerRadius = cell.marketView.frame.size.width/2
            cell.marketView.clipsToBounds = true
            
            cell.titleLabel.text = "Posição"
            
            var incomeValue = 0.0
            
            if stocksVC.stockList.count == 0 {
                cell.valueLabel.text = MathOperations.currencyFormatter(value: 0.0)
                
            } else {
                cell.valueLabel.text = MathOperations.currencyFormatter(value: stocksCurrentPrice())
                
                incomeValue = Double(MathOperations.calculateIncome(value1: stocksCurrentPrice(), value2: investedValue()))
            }
            
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "stocksCell", for: indexPath) as! StockCell
            
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            
            cell.collectionView.reloadData()
            
            return cell
            
        // MARK: - Default Card
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell", for: indexPath) as! SimpleCell
            
            guard let date = stocksVC.data1[0].lastUpdateStock else {
                return UITableViewCell()
            }
            
            cell.titleLabel.text = "Última atualização: \(MathOperations.formatDate(lastUpdate: date))"
            
            return cell
        }
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
        
        // MARK: - Stock cell
        if indexPath.row != stocksVC.stockList.count{
            
            let cellCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "stockCollectionCell", for: indexPath) as! StockCollectionViewCell
            
            cellCollection.stockView.layer.cornerRadius = 10.0
            cellCollection.symbolLabel.text = stocksVC.data2[stocksVC.index[indexPath.row]].symbol
            
            guard let change = stocksVC.data2[stocksVC.index[indexPath.row]].changePercentage else {
                return cellCollection
            }
            
            if change.contains("-") {
                cellCollection.changePercentageLabel.textColor = #colorLiteral(red: 0.9352485538, green: 0.128194809, blue: 0.1147380844, alpha: 1)
            } else {
                if change == "0%" {
                    cellCollection.changePercentageLabel.textColor = #colorLiteral(red: 0.9408631921, green: 0.9652459025, blue: 0.9907889962, alpha: 1)
                } else {
                    cellCollection.changePercentageLabel.textColor = #colorLiteral(red: 0, green: 0.7549133897, blue: 0.1463539004, alpha: 1)
                }
            }
            
            cellCollection.changePercentageLabel.text = "\(change)%"
            
            cellCollection.priceLabel.text = MathOperations.currencyFormatter(value: stocksVC.data2[stocksVC.index[indexPath.row]].price)
            
                return cellCollection
        
        // MARK: - Default cell
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
            stocksVC.selectedStock = stocksVC.data2[stocksVC.index[indexPath.row]].symbol ?? ""
            
            stocksVC.performSegue(withIdentifier: "detailStockSegue", sender: self)
        
        } else{
            verifyMarket(purpose: "buyAndSell")
        }
    }
    
    // MARK: - Market verification
    func verifyMarket(purpose: String){
        
        guard let stocksVC = stocksViewController else {
            return
        }
        
        let marketStatus = MarketManager.verifyMarket(purpose: purpose)
        
        if marketStatus == "Market closed" {
            stocksVC.marketColor = #colorLiteral(red: 0.1047265753, green: 0.2495177984, blue: 0.4248503447, alpha: 1)
            stocksVC.marketLabel = "Mercado fechado"
            
        } else if marketStatus == "Market open" {
            stocksVC.marketColor = #colorLiteral(red: 0.4889312983, green: 0.7110515833, blue: 1, alpha: 1)
            stocksVC.marketLabel = "Mercado aberto"
                
        } else if marketStatus == "Market closed alert" {
            stocksVC.createAlert(title: "Mercado fechado", message: "Operações só podem ser realizadas entre 10:00 e 17:00.", actionTitle: "OK")
            
        } else if marketStatus == "Market closed alert 2" {
            stocksVC.createAlert(title: "Mercado fechado", message: "Operações só podem ser realizadas em dias úteis.", actionTitle: "OK")
            
        } else if marketStatus == "Operations avilable" {
            stocksVC.performSegue(withIdentifier: "addStockSegue", sender: self)
            
        } else {
            print("Error at market verification")
        }
    }
    
    // MARK: - Math Operations
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
    
}
