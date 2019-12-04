//
//  MeViewController.swift
//  ThriftyApp
//
//  Created by Yusen Wang on 12/3/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {

    @IBOutlet var logOutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logOutTapped(_ sender: Any) {
        
        
        //sign user out
        UserDefaults.standard.removeObject(forKey: "isLogin")
        
        //navigate to log in view controller
        showLoginView()
    }
    
    func showLoginView(){
        let mainView = storyboard?.instantiateViewController(identifier: "RootController")
        view.window?.rootViewController = mainView
        view.window?.makeKeyAndVisible()
    }
}
