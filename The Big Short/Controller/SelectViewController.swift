//
//  SelectViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 30/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var investmentsTitles = ["Ações", "Títulos Públicos", "Dólar", "Poupança"]
    
    var investmentsDescription = ["Mercado de ações, com os 66 ativos do IBOVESPA.", "Tesouro direto: o investimento mais seguro do país.", "Comercialização de dólar americano (USD).", "Investimento de renda fixa mais popular no Brasil."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectCell", for: indexPath) as! SimpleCell
        
        cell.simpleView.layer.cornerRadius = 10.0
        
        cell.titleLabel.text = investmentsTitles[indexPath.row]
        
        cell.descriptionLabel.text = investmentsDescription[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            performSegue(withIdentifier: "selectStockSegue", sender: self)
        } else if indexPath.row == 1{
            
        } else if indexPath.row == 2{
            
        } else {
            
        }
            
    }
    

}
