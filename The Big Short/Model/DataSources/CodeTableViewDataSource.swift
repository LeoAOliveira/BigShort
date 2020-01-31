//
//  CodeTableViewDataSource.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 30/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import Foundation

class CodeTableViewDataSource: NSObject, UITableViewDataSource {
    
    weak var codeViewController: CodeViewController?
    
    init(viewController: CodeViewController) {
        codeViewController = viewController
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
        
        guard let codeVC = codeViewController else {
            return UITableViewCell()
        }
        
        guard let symbol = codeVC.data4[codeVC.index].symbol else {
            return UITableViewCell()
        }
        
        guard let name = codeVC.data4[codeVC.index].name else {
            return UITableViewCell()
        }
        
        let invested = Float(codeVC.data4[codeVC.index].invested)
        let investedBRL = Float(codeVC.data4[codeVC.index].investedBRL)
        let price = Float(codeVC.data4[codeVC.index].price)
        let mediumValue = Float(codeVC.data4[codeVC.index].mediumPrice)
        
        let value = MathOperations.currencyFormatter(value: Float(invested*price))
        let priceCurrency = MathOperations.currencyFormatter(value: Float(price))
        let mediumPrice = MathOperations.currencyFormatter(value: Float(mediumValue))
        let change = MathOperations.calculateChange(value1: investedBRL, value2: invested*price)
        
        // MARK: - Position Card
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "positionCell", for: indexPath) as! InvestmentsCell
            
            cell.titleLabel.text = "Posição"
            
            cell.valueLabel.text = value
            cell.valueLabel.text = value
            cell.currencyValueLabel.text = "\(symbol) \(String(format: "%.2f", invested))"
            
            let incomeValue = Double(MathOperations.calculateIncome(value1: invested*price, value2: investedBRL))
            
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
        
        // MARK: - Country Card
        } else if indexPath.row == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! SimpleCell
            
            cell.simpleView.layer.cornerRadius = 10.0
            
            cell.titleLabel.text = name
            cell.descriptionLabel.text = codeVC.data4[codeVC.index].region!
            cell.imageLogo.image = UIImage(named: "\(symbol).png")
            
            return cell
            
            
        // MARK: - Today Card
        } else if indexPath.row == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! TodayCell
            
            cell.todayView.layer.cornerRadius = 10.0
            cell.todaySubView.layer.cornerRadius = 10.0
            cell.titleLabel.text = "Hoje (\(formatDate()))"
            
            cell.priceLable.text = priceCurrency
            
            return cell
            
        // MARK: - History Card
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "histCell", for: indexPath) as! HistoricCell
            
            cell.histView.layer.cornerRadius = 10.0
            cell.histSubView.layer.cornerRadius = 10.0
            cell.mediumPriceLabel.text = mediumPrice
            
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
            
        // MARK: - Default Card
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
