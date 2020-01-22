//
//  StocksTableViewDelegate.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 17/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit

class StocksTableViewDelegate: NSObject, UITableViewDelegate {
    
    weak var stocksViewController: StocksViewController?
    
    init(viewController: StocksViewController) {
        stocksViewController = viewController
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 220
            
        } else {
            
            guard let stocksVC = stocksViewController else {
                return 470
            }
            
            if (stocksVC.stockList.count + 1) <= 3 {
                return 295
                
            } else{
                return 470
            }
        }
    }
}
