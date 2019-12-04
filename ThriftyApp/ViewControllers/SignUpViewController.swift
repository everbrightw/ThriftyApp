//
//  SignUpViewController.swift
//  ThriftyApp
//
//  Created by Yusen Wang on 12/2/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initComponentsStyle()
        setUpTapAnywhereToDissmissKeyBoard()
    }
    
    func setUpTapAnywhereToDissmissKeyBoard(){
        self.setupToHideKeyboardOnTapOnView()
        firstNameTextField.delegate = self as? UITextFieldDelegate
        lastNameTextField.delegate = self as? UITextFieldDelegate
        addressTextField.delegate = self as? UITextFieldDelegate
        emailTextField.delegate = self as? UITextFieldDelegate
        phoneTextField.delegate = self as? UITextFieldDelegate
        passwordTextField.delegate = self as? UITextFieldDelegate
    }
    
    func initComponentsStyle(){
        
        // hide error label
        errorLabel.alpha = 0
        // setting up placeholder color
        firstNameTextField.attributedPlaceholder = NSAttributedString(string:"First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string:"Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        addressTextField.attributedPlaceholder = NSAttributedString(string:"Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        phoneTextField.attributedPlaceholder = NSAttributedString(string:"Phone", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        //customize login button
        signUpButton.layer.cornerRadius = 10
        signUpButton.clipsToBounds = true
    }
    
    func postApiCall(jsonData: Data, url:URL) {
        
        if !jsonData.isEmpty {
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
    
    func validateFields()-> String? {
        //checking if all fields are filled
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Some fields are not filled"
        }
        
        
        return nil
    }
    
    fileprivate func showErrorMessage(_ errorMessage: String?) {
        //field are not validate
        errorLabel.text = errorMessage
        //show error message
        errorLabel.alpha = 1
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        // validate field
        let errorMessage = validateFields()
        
        if errorMessage != nil{
            showErrorMessage(errorMessage)
        }
        else{
            let newUser: User = User(firstname: firstNameTextField.text!, lastname: lastNameTextField.text!, email: emailTextField.text!, phone: phoneTextField.text!, password: passwordTextField.text!)
            
            let jsonEncoder = JSONEncoder()
            do {
                let jsonData = try jsonEncoder.encode(newUser)
                let jsonString = String(data: jsonData, encoding: .utf8)
                print("JSON String : " + jsonString!)
                print(jsonData.count)
                postApiCall(jsonData: jsonData, url: URL(string: Constants.zzkIPAddress + "/thrifty/api/v1.0/users")!)
                
                //dismis sign up page
                self.dismiss(animated: true, completion: .none)
            }
            catch {
            }
        }
    }
    

}
