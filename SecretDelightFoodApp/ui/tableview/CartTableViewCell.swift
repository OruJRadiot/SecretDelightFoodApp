//
//  CartTableViewCell.swift
//  SecretDelightFoodApp
//
//  Created by Oruj Dursunzade on 22.12.22.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var cartFoodCellContainer: UIView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var lblOrderAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
