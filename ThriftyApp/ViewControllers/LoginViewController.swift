//
//  ViewController.swift
//  ThriftyApp
//
//  Created by Yusen Wang on 12/2/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit


// MARK: -controlling user page
class LoginViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    let backgroundImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // dissmiss keyboard when tap view or user press a return
       self.setupToHideKeyboardOnTapOnView()
        emailTextField.delegate = self as? UITextFieldDelegate
        passwordTextField.delegate = self as? UITextFieldDelegate
        
        
        // test get api call
        getApiCall(url: "http://0.0.0.0:5000/thrifty/api/v1.0/users")
        
        
        //styling ui components
        initComponentStyles()
     
        //dismiss error label
        errorLabel.alpha = 0
    }
    
    // MARK: -initializing component
    func initComponentStyles(){
        
        titleLabel.textColor = .white
        initTitleLabelStyle()
        initEmailTextFieldStyle()
        initPasswordTextFieldStyle()
        initLoginButton()
        setBackground()
    }
    
    func initEmailTextFieldStyle(){
        
        emailTextField.setLeftImage(imageName: "email-icon")
        // set placeholder default text
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func initPasswordTextFieldStyle(){
        passwordTextField.setLeftImage(imageName: "password-icon")
               // setting up placeholder color
               
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func initTitleLabelStyle(){
        // style title
        let myMutableString = NSMutableAttributedString(string: "Thrifty", attributes: [NSAttributedString.Key.font :UIFont(name: "Avenir Black", size: 48.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named:"UIUCOrange"), range: NSRange(location:1,length:1))
        
        titleLabel.attributedText = myMutableString
    }
    
    func initLoginButton(){
        //customize login button
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
    }
    
    // MARK: -Set login page image background
    func setBackground(){
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.image = UIImage(named:"home-page-image")
        backgroundImageView.alpha = 0.1
        
    }

    
    
    
    
    
    
    
    
    
    
    
    // MARK: -get api call example
    func getApiCall(url: String){
        
        let jsonUrlString = url
                guard let url = URL(string: jsonUrlString) else { return }
                
                URLSession.shared.dataTask(with: url) { (data, response, err) in
                    //perhaps check err
                    
                    guard let data = data else { return }
        
                    do {
            
                        let courses = try JSONDecoder().decode([User].self, from: data)
                        print(courses)
                        print(courses[0].email)
                    } catch let jsonErr {
                        print("Error serializing json:", jsonErr)
                    }
                
                }.resume()
    }
    
    


}

extension UIViewController{
    
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


extension UITextField{
    // MARK: -Add icon indicator on left of text field
    func setLeftImage(imageName:String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: imageName)
        imageView.tintColor = UIColor.white
        self.leftView = imageView;
        self.leftViewMode = .always
    }
}
