//
//  SymbolTableViewDataSource.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 30/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import Foundation

class SymbolTableViewDataSource: NSObject, UITableViewDataSource {
    
    weak var symbolViewController: SymbolViewController?
    
    init(viewController: SymbolViewController) {
        symbolViewController = viewController
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let symbolVC = symbolViewController else {
            return UITableViewCell()
        }
        
        let positionPrice = symbolVC.data2[symbolVC.index].price * symbolVC.data2[symbolVC.index].amount
        let invested = symbolVC.data2[symbolVC.index].invested
        let price = symbolVC.data2[symbolVC.index].price
        let mediumPrice = symbolVC.data2[symbolVC.index].mediumPrice
        let amount = symbolVC.data2[symbolVC.index].amount
        
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "positionCell", for: indexPath) as! InvestmentsCell
            
            cell.titleLabel.text = "Posição"
            cell.valueLabel.text = MathOperations.currencyFormatter(value: positionPrice)
            
            let income = Double(MathOperations.calculateIncome(value1: positionPrice, value2: invested))
            
            if income > 0.0{
                cell.descriptionLabel.textColor = #colorLiteral(red: 0, green: 0.7020406723, blue: 0.1667427123, alpha: 1)
                cell.descriptionLabel.text = "+ \(MathOperations.currencyFormatter(value: Float(income)))"
                
            } else if income < 0.0{
                cell.descriptionLabel.textColor = #colorLiteral(red: 0.7722620368, green: 0.0615144521, blue: 0.1260437667, alpha: 1)
                cell.descriptionLabel.text = "- \(MathOperations.currencyFormatter(value: Float(income)))"
                
            } else{
                cell.descriptionLabel.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
                cell.descriptionLabel.text = "\(MathOperations.currencyFormatter(value: Float(income)))"
            }
            
            return cell
        
        // Position Card
        } else if indexPath.row == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "companyCell", for: indexPath) as! SimpleCell
            
            cell.simpleView.layer.cornerRadius = 10.0
            
            cell.titleLabel.text = symbolVC.data2[symbolVC.index].name!
            cell.descriptionLabel.text = "Setor: \(symbolVC.data2[symbolVC.index].sector!)"
            cell.imageLogo.image = UIImage(named: "\(symbolVC.data2[symbolVC.index].imageName!).pdf")
            
            return cell
            
            
        // Today
        } else if indexPath.row == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! TodayCell
            
            cell.todayView.layer.cornerRadius = 10.0
            cell.todaySubView.layer.cornerRadius = 10.0
            cell.titleLabel.text = "Hoje (\(formatDate()))"
            cell.changeLabel.text = MathOperations.currencyFormatter(value: positionPrice)
            
            guard let change = symbolVC.data2[symbolVC.index].changePercentage else {
                return cell
            }
            
            if change.contains("-") {
                cell.changeLabel.textColor = #colorLiteral(red: 0.7725490196, green: 0.06274509804, blue: 0.1254901961, alpha: 1)
            } else {
                if change == "0%" {
                    cell.changeLabel.textColor = #colorLiteral(red: 0.9408631921, green: 0.9652459025, blue: 0.9907889962, alpha: 1)
                } else {
                    cell.changeLabel.textColor = #colorLiteral(red: 0.1176470588, green: 0.6901960784, blue: 0.2549019608, alpha: 1)
                }
            }
            
            cell.changeLabel.text = change
            cell.priceLable.text = MathOperations.currencyFormatter(value: price)
            
            return cell
            
        // Hist
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "histCell", for: indexPath) as! HistoricCell
            
            cell.histView.layer.cornerRadius = 10.0
            cell.histSubView.layer.cornerRadius = 10.0
            cell.mediumPriceLabel.text = MathOperations.currencyFormatter(value: mediumPrice)
            cell.amountLabel.text = "\(Int(amount))"
            
            let change = MathOperations.calculateChange(value1: invested, value2: positionPrice)
            
            if change > 0.0{
                cell.totalChangeLabel.textColor = #colorLiteral(red: 0, green: 0.7020406723, blue: 0.1667427123, alpha: 1)
                cell.totalChangeLabel.text = "+\(String(format: "%.2f", change))%"
                
            } else if change < 0.0{
                cell.totalChangeLabel.textColor = #colorLiteral(red: 0.7722620368, green: 0.0615144521, blue: 0.1260437667, alpha: 1)
                cell.totalChangeLabel.text = "\(String(format: "%.2f", change))%"
                
            } else{
                cell.totalChangeLabel.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
                cell.totalChangeLabel.text = "\(String(format: "%.2f", change))%"
            }
            
            return cell
            
            
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "investmentsCell", for: indexPath) as! InvestmentsCell
            
            cell.titleLabel.text = ""
            cell.valueLabel.text = ""
            cell.descriptionLabel.text = ""
            
            return cell
        }
    }
    
    // MARK: - Math Operations
    
    func formatDate() -> String{
        
        let lastUpdate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        dateFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        
        return dateFormatter.string(from: lastUpdate)
    }
}
