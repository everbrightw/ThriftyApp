//
//  HomeTableViewController.swift
//  ThriftyApp
//
//  Created by Yusen Wang on 12/3/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit
var globalIndex: Int = 0;
var items: [DisplayItem] = []// items Array
// MARK: -representing home table view 
class HomeTableViewController: UIViewController,UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var fireIcon: UIImageView!
    @IBOutlet var searchBar: UISearchBar!
    
    let cellSpacingHeight: CGFloat = 50 // spacing between each cell
    
    //let searchItem: DisplayItem;
    
    let semaphore = DispatchSemaphore(value: 0)// i finally realize cs241 is useful
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initStyles()
        self.setupToHideKeyboardOnTapOnView()
        searchBar.delegate = self as? UISearchBarDelegate
        searchBar.returnKeyType = UIReturnKeyType.done
        
        getApiCall(url: Constants.zzkIPAddress + "/thrifty/api/v1.0/hottest")
        
        // wait until the asycn task is finished
//        semaphore.wait(timeout: DispatchTime.distantFuture)
        initTableView()
        titleLabel.text = "Hottest"
        print("")
    }

    func initTableView(){
        // set delegates and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor(named:"BackgroundColor")
    }
    
    func initStyles(){
        initSearchBarStyle()
        initIconStyle()
        print("style init??")
    }

    func initSearchBarStyle(){
        searchBar.barTintColor = UIColor(named: "BackgroundColor")
    }
    func initIconStyle(){
        fireIcon.tintColor = UIColor.white
    }

    func getApiCall(url: String){
        var searchResultItems: [DisplayItem] = []
        let jsonUrlString = url
                guard let url = URL(string: jsonUrlString) else { return }
                
                URLSession.shared.dataTask(with: url) { (data, response, err) in
                    //perhaps check err
                    
                    guard let data = data else { return }
        
                    do {
            
                        let entities = try JSONDecoder().decode([DisplayItem].self, from: data)
     
                        
                        // populate items arrays
                        for (index, _) in entities.enumerated(){
                            searchResultItems.append(DisplayItem(name:entities[index].name, price:entities[index].price, views: entities[index].views, category: entities[index].category, description: entities[index].description, email: entities[index].email))
                        }
                        self.semaphore.signal()
                    } catch let jsonErr {
                        print("Error serializing json:", jsonErr)
                    }
                
                }.resume()
        
        self.semaphore.wait(timeout: DispatchTime.distantFuture)
        items.removeAll()
        items = searchResultItems
        tableView.reloadData()
        titleLabel.text = "Hottest"
        
    }
    
    func searchApiCall(searchText: String){
        var searchResultItems: [DisplayItem] = []
        let jsonUrlString = Constants.zzkIPAddress + "/thrifty/api/v1.0/entity/search/" + searchText
           guard let url = URL(string: jsonUrlString) else { return }
           
           URLSession.shared.dataTask(with: url) { (data, response, err) in
               //perhaps check err
               
               guard let data = data else { return }
   
               do {

                   print("datasize", data.count)
                   let entities = try JSONDecoder().decode([DisplayItem].self, from: data)
                    print("entities", entities.count)
                   // populate items arrays
                   for (index, _) in entities.enumerated(){
                       
                    searchResultItems.append(DisplayItem(name:entities[index].name, price:entities[index].price, views: entities[index].views, category: entities[index].category, description: entities[index].description, email: entities[index].email))
                   }
                   self.semaphore.signal()
                
               } catch let jsonErr {
                   print("Error serializing json:", jsonErr)
               }
           
           }.resume()
        // waiting for update result
         self.semaphore.wait(timeout: DispatchTime.distantFuture)
         print("search result items", searchResultItems.count)
         items.removeAll()
         items = searchResultItems
         tableView.reloadData()
         titleLabel.text = "Results"
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        searchApiCall(searchText: searchBar.text!)
        self.dismissKeyboard()
    }
    
    @IBAction func reloadHotestItem(_ sender: Any) {
        
        getApiCall(url: Constants.zzkIPAddress + "/thrifty/api/v1.0/hottest")
        
    }
    //    func createTestData() -> [DisplayItem]{
//        let one: DisplayItem = DisplayItem(name: "pencil", price: "$55")
//        let two: DisplayItem = DisplayItem(name: "pencil", price: "$55")
//        let three: DisplayItem = DisplayItem(name: "pencil", price: "$55")
//        let four: DisplayItem = DisplayItem(name: "pencil", price: "$55")
//        let five: DisplayItem = DisplayItem(name: "pencil", price: "$55")
//        let six: DisplayItem = DisplayItem(name: "pencil", price: "$55")
//        let eight: DisplayItem = DisplayItem(name: "pencil", price: "$55")
//        return [one,two,three,four,five,six,eight]
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// Construct Table List View
extension HomeTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    // number of items total
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    // for blank space
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // setting cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        globalIndex = indexPath.section
        performSegue(withIdentifier: "DetailView", sender: self)
    }
    
}

