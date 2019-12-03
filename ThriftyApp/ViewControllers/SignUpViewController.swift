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

}
