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
            
        } else if indexPath.row == 1 {
            return 175
        
        } else {
            return 155
        }
    }
}
