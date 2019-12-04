//
//  User.swift
//  ThriftyApp
//
//  Created by Yusen Wang on 12/2/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import Foundation
import UIKit

struct User: Codable {
    var email: String
    var firstname: String
    var lastname: String
    var phone: String
    var password: String
    
    init(json: [String: Any]){
        email = json["email"] as? String ?? "email not found"
        firstname = json["firstname"] as? String ?? "name not found"
        lastname = json["lastName"] as? String ?? "name not found"
        phone = json["phone"] as? String ?? "phone not found"
        password = json["password"] as? String ?? "password not found"
        
    }
    
    init(firstname: String, lastname: String, email: String, phone: String, password: String){
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.phone = phone
        self.password = password
    }
}

struct LoginUser:Codable{
    
    var email: String

    var password: String
    
    init(json: [String: Any]){
        email = json["email"] as? String ?? "email not found"

        password = json["password"] as? String ?? "password not found"
        
    }
    
    init(email: String, password: String){

        self.email = email
        self.password = password
    }
}

