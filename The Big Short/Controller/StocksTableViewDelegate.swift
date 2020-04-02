//
//  StocksTableViewDelegate.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 17/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import Foundation

class StocksTableViewDelegate: NSObject, UITableViewDelegate {
    
    weak var stocksViewController: StocksViewController?
    
    init(viewController: StocksViewController) {
        stocksViewController = viewController
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 220
            } else {
                return 270
            }
            
        } else if indexPath.row == 1 {
            
            guard let stocksVC = stocksViewController else {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    return 180
                } else {
                    return 500
                }
            }
            
            let traitCollection = stocksVC.view.traitCollection
            
            let stockList = stocksVC.stockList.count
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                
                let cells: Double = (Double(stockList) + 1.0) / 3.0
                let rows: Int = Int(cells.rounded(.up)) - 1
                
                return CGFloat(180 + (rows * 145))
                
            } else {
                
                if traitCollection.horizontalSizeClass == .compact {
                    
                    let cells: Double = (Double(stockList) + 1.0) / 3.0
                    let rows: Int = Int(cells.rounded(.up)) - 1
                    
                    return CGFloat(180 + (rows * 145))
                    
                } else {
                    
                    let total = (140 * 5) + (10 * 4) + (80 * 2)
                    
                    if UIScreen.main.bounds.width >= CGFloat(total) {
                        let cells: Double = (Double(stockList) + 1.0) / 5.0
                        let rows: Int = Int(cells.rounded(.up)) - 1
                        return CGFloat(250 + (rows * 215))
                        
                    } else {
                        let cells: Double = (Double(stockList) + 1.0) / 4.0
                        let rows: Int = Int(cells.rounded(.up)) - 1
                        return CGFloat(250 + (rows * 215))
                    }
                }
            }
        
        } else {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 80
            } else {
                return 100
            }
        }
    }
}
