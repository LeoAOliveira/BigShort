//
//  CurrenciesDelegate.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 23/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit

class CurrenciesTableViewDelegate: NSObject, UITableViewDelegate {
    
    weak var currenciesViewController: CurrenciesViewController?
    
    init(viewController: CurrenciesViewController) {
        currenciesViewController = viewController
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 200
            
        } else {
            return 225
        }
    }
}
