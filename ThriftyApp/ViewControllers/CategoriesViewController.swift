//
//  CategoriesViewController.swift
//  ThriftyApp
//
//  Created by Yusen Wang on 12/3/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit

// MARK: -categories view controller
class CategoriesViewController: UIViewController {

    @IBOutlet var electronicButton: UIButton!
    @IBOutlet var clothesButton: UIButton!
    @IBOutlet var accessories: UIButton!
    @IBOutlet var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initButtonStyles()
    }
    
    func initButtonStyles(){
        
        electronicButton.setRoundedButton()
        clothesButton.setRoundedButton()
        accessories.setRoundedButton()
        homeButton.setRoundedButton()
        
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
