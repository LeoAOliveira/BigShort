//
//  GlossaryViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 31/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class GlossaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    public var data3: [Glossary] = []
    var context: NSManagedObjectContext?
    
    var selectedWord = " "
    
    var wordsArray = [Glossary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.0438792631, green: 0.1104110107, blue: 0.1780112088, alpha: 1)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        fetchData()
        dismissKeyboard()
    }
    
    // MARK: - Fetch from CoreData
    
    func fetchData(){
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            data3 = try context!.fetch(Glossary.fetchRequest())
            
            wordsArray = data3
            
        } catch{
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source and delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "worldCell") as? WordCell else{
            return UITableViewCell()
        }
        
        cell.wordLabel.text = wordsArray[indexPath.row].word
        cell.wordView.layer.cornerRadius = 10.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            wordsArray = data3
            tableView.reloadData()
            return
        }
        
        wordsArray = data3.filter({ word -> Bool in
            word.word!.lowercased().range(of: searchText.lowercased(), options: [.diacriticInsensitive, .caseInsensitive]) != nil
        })
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Dismiss Keyboard
    
    func dismissKeyboard() {
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "glossarySegue" {
            
            selectedWord = (sender as! WordCell).wordLabel.text!
            
            let destination = segue.destination as! DetailViewController
            destination.word = selectedWord
            destination.parentVC = self
            
        }
    }
}
