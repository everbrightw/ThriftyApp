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
    var name: String
    var phone: String
    init(json: [String: Any]){
        email = json["email"] as? String ?? "email not found"
        name = json["name"] as? String ?? "name not found"
        phone = json["phone"] as? String ?? "phone not found"
    }
}
