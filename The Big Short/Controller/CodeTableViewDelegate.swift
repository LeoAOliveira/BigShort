//
//  CodeTableViewDelegate.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 30/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit
import Foundation

class CodeTableViewDelegate: NSObject, UITableViewDelegate {
    
    weak var codeViewController: CodeViewController?
    
    init(viewController: CodeViewController) {
        codeViewController = viewController
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 170
        
        } else if indexPath.row == 1 {
            return 110
        
        } else if indexPath.row == 2 {
           return 160
            
        } else if indexPath.row == 3 {
           return 160
            
        } else{
            return 190
        }
    }
}
