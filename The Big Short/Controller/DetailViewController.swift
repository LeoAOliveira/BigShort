//
//  DetailViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 31/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class DetailViewController: UIViewController {

    // @IBOutlet weak var wordView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var urlTextView: UITextView!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    var word: String!
    var index: Int!
    
    var parentVC: UIViewController!
    
    public var data3: [Glossary] = []
    
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // wordView.layer.cornerRadius = 10.0
        titleLabel.text = word
        titleLabel.numberOfLines = 0
        // navBarTitle.title = word
        
        fetchData()
        
        descriptionLabel.text = data3[index].meaning
        descriptionLabel.numberOfLines = 0
        
        sourceLabel.text = data3[index].source
        sourceLabel.numberOfLines = 0
        
        urlTextView.text = data3[index].sourceURL
        urlTextView.sizeToFit()
    }
        
    func fetchData(){
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            data3 = try context!.fetch(Glossary.fetchRequest())
            
            for i in 0...data3.count-1{
                if data3[i].word == word{
                    index = i
                }
            }
            
        } catch{
            print(error.localizedDescription)
        }
    }
}
