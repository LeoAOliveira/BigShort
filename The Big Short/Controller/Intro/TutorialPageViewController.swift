//
//  TutorialPageViewController.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 04/08/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import Foundation

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    var viewControllerList: [UIViewController] = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = storyboard.instantiateViewController(withIdentifier: "Tutoria1VC")
        let vc2 = storyboard.instantiateViewController(withIdentifier: "Tutoria2VC")
        let vc3 = storyboard.instantiateViewController(withIdentifier: "Tutoria3VC")
        let vc4 = storyboard.instantiateViewController(withIdentifier: "Tutoria4VC")
        let vc5 = storyboard.instantiateViewController(withIdentifier: "Tutoria5VC")
        let vc6 = storyboard.instantiateViewController(withIdentifier: "Tutoria6VC")
        let vc7 = storyboard.instantiateViewController(withIdentifier: "Tutoria7VC")
        
        return [vc1, vc2, vc3, vc4, vc5, vc6, vc7]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataManager().checkForInitialData(){ isValid in
                
            if isValid == true {
                
                self.view.backgroundColor = #colorLiteral(red: 0.0438792631, green: 0.1104110107, blue: 0.1780112088, alpha: 1)
                self.dataSource = self
                
                if let firstViewController = self.viewControllerList.first{
                    self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
                }
                
            } else {
                print("Error checkForInitialData")
            }
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        
        guard nextIndex != 0 else {return nil}
        
        guard viewControllerList.count > nextIndex else {return nil}
        
        return viewControllerList[nextIndex]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
