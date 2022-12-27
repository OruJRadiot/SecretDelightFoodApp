//
//  AddViewController.swift
//  SecretDelightFoodApp
//
//  Created by Oruj Dursunzade on 20.12.22.
//

import UIKit
import Kingfisher

class AddScreen: UIViewController {
    // views
    @IBOutlet weak var addViewContainer: UIView!
    @IBOutlet weak var addViewDetailsContainer: UIView!
    
    // food displaying connections
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    
    // order amount and total
    @IBOutlet weak var tfOrderAmount: UILabel!
    @IBOutlet weak var orderTotal: UILabel!
    
    var food : Foods?
    let oruc : String = "oruc_dursunzade"
    var orderAmount : Int = 1
    
    var viewModel = AddViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewContainer.layer.cornerRadius = 10
        addViewDetailsContainer.layer.cornerRadius = 40
        addViewDetailsContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tfOrderAmount.text = "\(orderAmount)"
        tfOrderAmount.layer.borderWidth = 0.5
        tfOrderAmount.layer.borderColor = UIColor.black.cgColor
        
        if let f = food {
            let imageUrl = URL(string: "http://kasimadalan.pe.hu/foods/images/\(f.image!)")
            foodImage.kf.setImage(with: imageUrl)
            foodName.text = f.name
            foodPrice.text = "₼ \(f.price!)"
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        orderAmount = 1
        tfOrderAmount.text = "\(orderAmount)"
        calculateTotal()
//        orderTotal.text = "₼ \(calculateTotal(price : food!.price!, amount : orderAmount))"
        
    }
    
    @IBAction func btnIncrement(_ sender: UIButton) {
        orderAmount+=1
        tfOrderAmount.text = "\(orderAmount)"
        calculateTotal()
    }
    
    @IBAction func btnDecrement(_ sender: UIButton) {
        if orderAmount == 1{
            return
        }else{
            orderAmount-=1
            tfOrderAmount.text = "\(orderAmount)"
            calculateTotal()
        }
    }
    
    func calculateTotal(){
        let total = (food?.price)! * orderAmount
        orderTotal.text = "₼ \(total)"
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        if let f = food {
            viewModel.add(name: f.name!, image: f.image!, price: f.price!, category: f.category!, orderAmount: orderAmount, userName: oruc)
            
        }
        self.dismiss(animated: true)
    }
    
    
}
