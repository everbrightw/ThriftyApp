//
//  ClotheItemCell.swift
//  ThriftyApp
//
//  Created by Yusen Wang on 12/3/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit

class ClotheItemCell: UITableViewCell {

//    @IBOutlet var itemNameLabel: UILabel!
//    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var itemNameLabel: UILabel!
    
    @IBOutlet var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItemCell(item: DisplayItem){
            

            // styling
        self.backgroundColor = UIColor(named: "LightBackgroundColor")
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.gray.cgColor
        // styling icons to white
//            dollarSign.tintColor = .white
//            clockImage.tintColor = .white
//            locationImage.tintColor = .white
        
        // set cell value
        itemNameLabel.text = item.name
        priceLabel.text = item.price
            
    }

    @IBAction func favoriteButton(_ sender: Any) {
        print("clothes ??")
    }
}
