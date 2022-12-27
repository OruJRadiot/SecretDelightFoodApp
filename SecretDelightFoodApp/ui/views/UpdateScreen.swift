//
//  UpdateScreen.swift
//  SecretDelightFoodApp
//
//  Created by Oruj Dursunzade on 22.12.22.
//

import UIKit

class UpdateScreen: UIViewController {
    // View Containers
    @IBOutlet weak var updateViewContainer: UIView!
    @IBOutlet weak var updateViewDetailsContainer: UIView!
    
    // food displaying connections
    @IBOutlet weak var cartFoodImage: UIImageView!
    @IBOutlet weak var cartFoodName: UILabel!
    @IBOutlet weak var cartFoodPrice: UILabel!
    
    // order amount and total 
    @IBOutlet weak var tfOrderAmount: UILabel!
    @IBOutlet weak var orderTotal: UILabel!
    
    var cartFood : FoodsCart?
    let oruc : String = "oruc_dursunzade"
    var initialOrderAmount : Int?
    
    var viewModel = UpdateViewModel()
//    var addViewModel = AddViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewContainer.layer.cornerRadius = 10
        updateViewDetailsContainer.layer.cornerRadius = 40
        updateViewDetailsContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tfOrderAmount.layer.borderWidth = 0.5
        tfOrderAmount.layer.borderColor = UIColor.black.cgColor
        
        if let cf = cartFood {
            let imageUrl = URL(string: "http://kasimadalan.pe.hu/foods/images/\(cf.image!)")
            cartFoodImage.kf.setImage(with: imageUrl)
            cartFoodName.text = cf.name
            cartFoodPrice.text = "₼ \(cf.price!)"
            initialOrderAmount = cartFood!.orderAmount
            tfOrderAmount.text = "\(initialOrderAmount!)"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calculateTotal()
    }
    
    @IBAction func btnIncrement(_ sender: UIButton) {
        initialOrderAmount! += 1
        tfOrderAmount.text = "\(initialOrderAmount!)"
        calculateTotal()
    }
    
    @IBAction func btnDecrement(_ sender: UIButton) {
        if initialOrderAmount == 1{
            return
        }else{
            initialOrderAmount! -= 1
            tfOrderAmount.text = "\(initialOrderAmount!)"
            calculateTotal()
        }
    }
    
    func calculateTotal(){
        let total = (cartFood?.price)! * initialOrderAmount!
        orderTotal.text = "₼ \(total)"
    }
    
    @IBAction func updateCart(_ sender: UIButton) {
        if let cf = cartFood {
            viewModel.update(cartId: cf.cartId!, name: cf.name!, image: cf.image!, price: cf.price!, category: cf.category!, orderAmount: initialOrderAmount!, userName: oruc)
        }
        self.dismiss(animated: true)
        viewModel.loadFoodsCart(userName: oruc)
    }

}
