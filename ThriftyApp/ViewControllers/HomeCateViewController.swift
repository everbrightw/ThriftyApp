//
//  HomeCateViewController.swift
//  ThriftyApp
//
//  Created by Yusen Wang on 12/3/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit

class HomeCateViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

        // items Array
        var items: [DisplayItem] = []
        let cellSpacingHeight: CGFloat = 50 // spacing between each cell
        let semaphore = DispatchSemaphore(value: 0)// i finally realize cs241 is useful
            
        override func viewDidLoad() {
            super.viewDidLoad()
            
            initTableView()

            getApiCall(url: Constants.zzkIPAddress + "/thrifty/api/v1.0/entity/category/Home")
            // wait until the asycn task is finished
            semaphore.wait(timeout: DispatchTime.distantFuture)
            
            initTableView()
            print("")
        }

            func initTableView(){
                // set delegates and data source
                tableView.delegate = self
                tableView.dataSource = self
                
                tableView.backgroundColor = UIColor(named:"BackgroundColor")
            }
            
            func getApiCall(url: String){
                
                let jsonUrlString = url
                        guard let url = URL(string: jsonUrlString) else { return }
                        print("start")
                        URLSession.shared.dataTask(with: url) { (data, response, err) in
                            //perhaps check err
                            
                            guard let data = data else { return }
                
                            do {
                    
                                let entities = try JSONDecoder().decode([DisplayItem].self, from: data)
                                print(entities)
                                print("clothes????" + entities[0].name)
                                
                                // populate items arrays
                                for (index, _) in entities.enumerated(){
                                    self.items.append(DisplayItem(name:entities[index].name, price:entities[index].price, views: entities[index].views, category: entities[index].category, description: entities[index].description, email: entities[index].email))
                                }
                                self.semaphore.signal()
                            } catch let jsonErr {
                                print("Error serializing json:", jsonErr)
                            }
                        
                        }.resume()
            }
        
 
    //

        }

        // Construct Table List View
extension HomeCateViewController: UITableViewDataSource, UITableViewDelegate{
    
    // number of items total
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    // for blank space
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // setting cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeItemCell") as! HomeTableViewCell
        cell.setItemCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // add section
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame:CGRect (x: 0, y: 0, width: 320, height: 20) ) as UIView
        view.backgroundColor = UIColor(named:"BackgroundColor")
        return view
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


