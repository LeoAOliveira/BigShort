

//
//  CustomButton.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 05/08/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func draw(_ rect: CGRect) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
    }

}
