//
//  ViewController.swift
//  ThriftyApp
//
//  Created by Yusen Wang on 12/2/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit

var currentUserId: String = ""
// MARK: -controlling user page
class LoginViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    let backgroundImageView = UIImageView()
    
    var successLoggedIn: Bool = false
    
    let semaphore = DispatchSemaphore(value: 0)// i finally realize cs241 is useful

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // dissmiss keyboard when tap view anywhere or user press a return
        self.setupToHideKeyboardOnTapOnView()
        emailTextField.delegate = self as? UITextFieldDelegate
        passwordTextField.delegate = self as? UITextFieldDelegate
        
        
        // test get api call
        //getApiCall(url: "http://192.168.1.3.:5000/thrifty/api/v1.0/users")
        
        
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
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    func postApiCall(jsonData: Data, url:URL, completionHandler: @escaping CompletionHandler) {
        
        var flag = true // true if download succeed,false otherwise
        
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
                let jsonString = String(data: responseData ?? Data(), encoding: .utf8)
                
                print("JSON String : " + jsonString!)
                let dict = self.convertToDictionary(text: jsonString!)
                print(dict)
                
                if((jsonString?.contains("isvalid"))!){
                    // passed authentication
                    print("checked is valid")
                    flag = true
                    print("when i am setting user id", dict!["UserId"] as! String)
                    currentUserId = dict!["UserId"] as! String
                    completionHandler(flag)
                    
                    
                }
                else{
                    flag = false
                    completionHandler(flag)
                }
                // semaphore signal waiting for this async test to complete
                self.semaphore.signal()
                
            })
            task.resume()
            
        }
        

    }
    
    func showHomeView(){
        let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") as! HomeViewController
                
            // TODO: Fix this
            // Select Tab
        mainTabController.selectedViewController = mainTabController.viewControllers?[1]// 0 indexed
    
        self.view.window?.rootViewController = mainTabController
        self.view.window?.makeKeyAndVisible()
    }
    
    func validateFields()-> String? {
        //checking if all fields are filled
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
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
    
    // MARK: -user tapped login button
    @IBAction func loginTapped(_ sender: Any) {
        
        let errorMessage = validateFields()
        
        if errorMessage != nil{
            showErrorMessage(errorMessage)
        }
        else{
            // posting for authentication
            let loginUser: LoginUser = LoginUser(email:emailTextField.text!, password:passwordTextField.text!)
            let jsonEncoder = JSONEncoder()
            
            do {
                
                let jsonData = try jsonEncoder.encode(loginUser)
                let jsonString = String(data: jsonData, encoding: .utf8)
                print("JSON String : " + jsonString!)
                print(jsonData.count)
                postApiCall(jsonData: jsonData, url: URL(string: Constants.zzkIPAddress + "/thrifty/api/v1.0/login/")!, completionHandler: { (success) -> Void in
                    // When download completes,control flow goes here.
                    if success {
                        // download success
                        print("user logged in")
                        UserDefaults.standard.set(currentUserId, forKey: "isLogin")
                        print("user id from login page", currentUserId)
                        //self.showHomeView()
                        self.successLoggedIn = true
                        
                    }
                    else {
                        // failed authentication
                        //self.showErrorMessage("Authentication Failed")
                        self.successLoggedIn = false
                        print("from login view controller 232: authentication process failed")
                    }
                })
            }
            catch {
            }
            // Thread will wait here until async task closure is complete
            semaphore.wait(timeout: DispatchTime.distantFuture)
            print("its time")
            if(successLoggedIn){
                self.showHomeView()
            }
            else{
                self.showErrorMessage("Authentication Failed")
            }
        }
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
//    let dict = convertToDictionary(text: str)
    
    


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

extension UIButton{
    func setRoundedButton(){
        //customize login button
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
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
