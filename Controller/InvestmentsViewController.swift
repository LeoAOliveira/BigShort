//
//  InvestmentsViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 30/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class InvestmentsViewController: UIViewController{

//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var navbarItem: UINavigationItem!
//
//    var selectedInvestment = " "
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        navbarItem.title = selectedInvestment
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        fetchData(investment: selectedInvestment)
//    }
//
//    func fetchData(investment: String){
//
//        if investment == "Títulos públicos"{
//
//
//        } else if investment == "Dólar"{
//
//
//        } else{
//
//
//        }
//
//        tableView.reloadData()
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        // Position Card
//        if indexPath.row == 0{
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "positionCell", for: indexPath) as! PositionCell
//
//            cell.positionView.layer.cornerRadius = 10.0
//
//            cell.titleLabel.text = "Posição"
//
//            var incomeValue = 0.0
//
//            if stockList.count == 0{
//                cell.totalValueLabel.text = numberFormatter(value: 0.0)
//
//            } else{
//                cell.totalValueLabel.text = numberFormatter(value: stocksCurrentPrice())
//                incomeValue = Double(calculateIncome(value1: stocksCurrentPrice(), value2: data1[0].totalValue))
//            }
//
//            cell.investedValueLabel.text = "Valor investido: \(numberFormatter(value: data1[0].totalValue))"
//
//            if incomeValue > 0{
//
//                cell.incomeLabel.text = "Rendimento: "
//                cell.incomeValueLabel.text = "+ \(numberFormatter(value: Float(incomeValue)))"
//                cell.incomeValueLabel.textColor = #colorLiteral(red: 0, green: 0.7020406723, blue: 0.1667427123, alpha: 1)
//
//            } else if incomeValue < 0{
//
//                cell.incomeLabel.text = "Prejuízo: "
//                cell.incomeValueLabel.text = "- \(numberFormatter(value: Float(incomeValue)))"
//                cell.incomeValueLabel.textColor = #colorLiteral(red: 0.7722620368, green: 0.0615144521, blue: 0.1260437667, alpha: 1)
//
//            } else{
//                cell.incomeLabel.text = "Rendimento: "
//                cell.incomeValueLabel.text = numberFormatter(value: Float(incomeValue))
//                cell.incomeValueLabel.textColor = #colorLiteral(red: 0.8195154071, green: 0.8196598291, blue: 0.8195170164, alpha: 1)
//            }
//
//        }
//
//        return cell
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }investmentsSegue
    */

}
