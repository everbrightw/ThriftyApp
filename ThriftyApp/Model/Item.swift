//
//  Item.swift
//  ThriftyApp
//
//  Created by Yusen Wang on 12/3/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import Foundation

class DisplayItem: Decodable{
    
    var name: String
    var price: String
    var views: String
    var category: String
    var description: String
    var email: String // email
//    var image: String
  
    init(name:String, price: String, views: String, category: String, description: String, email: String){
        self.name = name
        self.price = price
        self.views = views
        self.category = category
        self.description = description
        self.email = email
    }
    
    init(json: [String: Any]){
        name = json["name"] as? String ?? "name not found"
        price = json["price"] as? String ?? "price not found"
        views = json["views"] as? String ?? "price not found"
        category = json["category"] as? String ?? "price not found"
        description = json["description"] as? String ?? "price not found"
        email = json["email"] as? String ?? "price not found"
    }
    
    
}

class PostItem: Codable{
    
    var name: String
    var price: String
    var condition: String
    var category: String
    var description: String
    var userid: String
    var picture: String
//    var image: String
  
    init(name:String, price: String, condition: String, category: String, description: String, userid:String, picture: String){
        self.name = name
        self.price = price
        self.condition = condition
        self.category = category
        self.description = description
        self.userid = userid
        self.picture = picture
    }
    
    init(json: [String: Any]){
        name = json["name"] as? String ?? "name not found"
        price = json["price"] as? String ?? "price not found"
        condition = json["condition"] as? String ?? "price not found"
        category = json["category"] as? String ?? "price not found"
        description = json["description"] as? String ?? "price not found"
        userid = json["userid"] as? String ?? "price not found"
        picture = json["picture"] as? String ?? "price not found"
    }
}
