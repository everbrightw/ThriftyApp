//
//  DetailViewController.swift
//  ThriftyApp
//
//  Created by Yusen Wang on 12/4/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var viewsLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactLabel.text = items[globalIndex].email
        descriptionLabel.text = items[globalIndex].description
        viewsLabel.text = items[globalIndex].views
        categoryLabel.text = items[globalIndex].category
        priceLabel.text = items[globalIndex].price
        nameLabel.text = items[globalIndex].name
        
        // posting views ++
        postViews()
        
        
        // Do any additional setup after loading the view.
    }
    
    struct ViewHistory :Codable{
        var entity:String
        var userId:String
        
        init(entity: String, userId: String){
            self.entity = entity
            self.userId = userId
        }
        
        init(json: [String: Any]){
            entity = json["entity"] as? String ?? "entity not found"
            userId = json["userId"] as? String ?? "userid not found"
        }
    }
    
    func postViews(){
        
        let jsonEncoder = JSONEncoder()
        let url: URL = URL(string: Constants.zzkIPAddress + "/thrifty/api/v1.0/watch_history")!
        
        print("user id", UserDefaults.standard.value(forKey: "isLogin") as! String)
        let newView = ViewHistory(entity: items[globalIndex].name, userId: UserDefaults.standard.value(forKey: "isLogin") as! String)
        
        do{
            let jsonData = try jsonEncoder.encode(newView)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
            print(jsonData.count)
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
        catch{// handle parsing json data
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
