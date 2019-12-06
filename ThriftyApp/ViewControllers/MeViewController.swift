//
//  MeViewController.swift
//  ThriftyApp
//
//  Created by Yusen Wang on 12/3/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {

    @IBOutlet var resetPasswordTextField: UITextField!
    @IBOutlet var deleteAccountButton: UIButton!
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
    
    @IBAction func deleteAccountTapped(_ sender: Any) {
        
        // create the alert
        let alert = UIAlertController(title: "Adding Item", message: "Going to post this item?", preferredStyle: UIAlertController.Style.alert)

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: {action in
            
            //posting data to back end
            print("current usere logged in id", currentUserId)
            var request = URLRequest(url: URL(string: Constants.zzkIPAddress + "/thrifty/api/v1.0/users/delete/" + currentUserId)!)
            request.httpMethod = "DELETE"
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (responseData: Data?, response: URLResponse?, error: Error?) in
                NSLog("\(String(describing: response))")

            })
            task.resume()

            //sign user out
            UserDefaults.standard.removeObject(forKey: "isLogin")

            //navigate to log in view controller
            self.showLoginView()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {action in
            // canceled
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    typealias CompletionHandler = (_ success:Bool) -> Void
    @IBAction func resetPasswordButton(_ sender: Any) {
        
        var flag = true
        
        var request = URLRequest(url: URL(string: Constants.zzkIPAddress + "/thrifty/api/v1.0/users/" + currentUserId + "/" + resetPasswordTextField.text!)!)
        request.httpMethod = "PUT"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (responseData: Data?, response: URLResponse?, error: Error?) in
            NSLog("\(String(describing: response))")

        })
        task.resume()
        
        let alertController = UIAlertController(title: "Reset Password", message:
            "Password has been reset please relogin", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay",style: UIAlertAction.Style.default,
        handler: {(alert: UIAlertAction!) in
            
            UserDefaults.standard.removeObject(forKey: "isLogin")
            //navigate to log in view controller
            self.showLoginView()
        }))
        
         
        
    }
        
     
    
    func showLoginView(){
        let mainView = storyboard?.instantiateViewController(identifier: "RootController")
        view.window?.rootViewController = mainView
        view.window?.makeKeyAndVisible()
    }
}
