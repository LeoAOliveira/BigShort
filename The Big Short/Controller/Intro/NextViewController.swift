//
//  NextViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 11/08/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import Foundation

class NextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Next button
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        let defaults = UserDefaults()
        
        if defaults.string(forKey: "terms") != "terms"{
            
            performSegue(withIdentifier: "nextSegue", sender: self)
            
        }
    }
    

}
