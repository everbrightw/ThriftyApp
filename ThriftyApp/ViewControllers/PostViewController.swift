//
//  PostViewController.swift
//  ThriftyApp
//
//  Created by Yusen Wang on 12/3/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit

// MARK: -post view controller
class PostViewController: UIViewController {

    @IBOutlet var itemNameTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var conditionTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    
    @IBOutlet var discriptionTextField: UITextField!
    
    @IBOutlet var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up keyboard hiding
        self.setupToHideKeyboardOnTapOnView()
        itemNameTextField.delegate = self as? UITextFieldDelegate
        priceTextField.delegate = self as? UITextFieldDelegate
        conditionTextField.delegate = self as? UITextFieldDelegate
        categoryTextField.delegate = self as? UITextFieldDelegate
        descriptionTextField.delegate = self as? UITextFieldDelegate
        // Do any additional setup after loading the view.
    }
    
    func eraseTexts(){
        itemNameTextField.text = ""
        priceTextField.text = ""
        conditionTextField.text = ""
        categoryTextField.text = ""
        descriptionTextField.text = ""
    }
    
    // MARK: -display a notice alert
    func displayResultAlert(){
        let alertController = UIAlertController(title: "Adding Item", message:
            "Item has been successfully added", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayConfirmationAlert(){
        // create the alert
        let alert = UIAlertController(title: "Adding Item", message: "Going to post this item?", preferredStyle: UIAlertController.Style.alert)

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Post", style: UIAlertAction.Style.default, handler: {action in
            
            //posting data to back end
            do {
//                var name: String
//                var price: String
//                var condition: String
//                var categories: String
//                var discription: String
                let newItem = PostItem(
                    name: self.itemNameTextField.text!,
                    price: self.priceTextField.text!,
                    condition: self.conditionTextField.text!,
                    category: self.categoryTextField.text!,
                    description: self.discriptionTextField.text!,
                    userid: UserDefaults.standard.value(forKey: "isLogin") as! String, picture: "no picture")
                
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(newItem)
                let jsonString = String(data: jsonData, encoding: .utf8)
                print("JSON String : " + jsonString!)
                print(jsonData.count)
                self.postApiCall(jsonData: jsonData, url: URL(string: Constants.zzkIPAddress + "/thrifty/api/v1.0/entity/insert")!)
                
            }
            catch{
                
            }
            self.displayResultAlert()
            self.eraseTexts()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {action in
            // canceled
        }))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // post items data
    func postApiCall(jsonData: Data, url:URL){
        if !jsonData.isEmpty {
            
            //UserDefaults.standard.value(forKey: "isLogin")
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            request.httpBody = jsonData
            let jsonEncoder = JSONEncoder()
            print("i am sending data")
            URLSession.shared.getAllTasks { (openTasks: [URLSessionTask]) in
                NSLog("open tasks: \(openTasks)")
            }

            let task = URLSession.shared.dataTask(with: request, completionHandler: { (responseData: Data?, response: URLResponse?, error: Error?) in
                NSLog("\(String(describing: response))")
                // getting request
                do {
                    let jsonString = String(data: responseData ?? Data(), encoding: .utf8)
                    print("JSON String : " + jsonString!)
                }
                catch {
                }
                
            })
            task.resume()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        // diss miss all text field
        displayConfirmationAlert()
    }
}
