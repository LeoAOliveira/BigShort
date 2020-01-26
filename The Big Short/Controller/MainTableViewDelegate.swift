//
//  MainTableViewDelegate.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 20/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit

class MainTableViewDelegate: NSObject, UITableViewDelegate {
    
    weak var mainViewController: MainViewController?
    
    init(viewController: MainViewController) {
        mainViewController = viewController
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 200
            
        } else {
            
            guard let mainVC = mainViewController else {
                return 180
            }
            
            let stockList = mainVC.stockList.count
            
            let cells: Double = (Double(stockList) + 1.0) / 3.0
            
            let rows: Int = Int(cells.rounded(.up)) - 1
            
            return CGFloat(180 + (rows * 145))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            mainViewController?.performSegue(withIdentifier: "stockSegue", sender: mainViewController)
            
        } else if indexPath.row == 2 {
            mainViewController?.performSegue(withIdentifier: "currencySegue", sender: mainViewController)
            
        }
    }
}
