//
//  CartViewController.swift
//  SecretDelightFoodApp
//
//  Created by Oruj Dursunzade on 19.12.22.
//

import UIKit
import RxSwift
import Kingfisher

class CartScreen: UIViewController {

    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    
    var cartList = [FoodsCart]()
    let oruc : String = "oruc_dursunzade"
    var viewModel = CartViewModel()
    var filteredCartList = [FoodsCart]()
    var userFilterChoice : Int = 0
    var forGrandTotal = [FoodsCart]()
    var totalSum : Int = 0
    
    
    @IBOutlet weak var defaultSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        _ = viewModel.cartList.subscribe(onNext: { list in
            self.cartList = list
            self.cartTableView.reloadData()
            self.forGrandTotal = list
//            self.calculateGrandTotal()
        })
        _ = viewModel.totalSum.subscribe(onNext: { sum in
            self.grandTotal.text = "TOTAL  :  ₼ \(sum)"
        })
//        calculateGrandTotal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 1 OF 2 SAME FUNCTIONS SIMULTANEOUSLY RUNNING
        viewModel.loadFoodsCart(userName: oruc)
        defaultSegmentedControl.selectedSegmentIndex = 0
        _ = viewModel.totalSum.subscribe(onNext: { sum in
            self.grandTotal.text = "TOTAL  :  ₼ \(sum)"
        })
//        calculateGrandTotal()
    }
    
    
    @IBAction func cartCategoryFilter(_ sender: UISegmentedControl) {
        userFilterChoice = sender.selectedSegmentIndex
//        viewModel.loadFoodsCart(userName: oruc)
        viewModel.filterCart(userChoice: userFilterChoice)
        cartTableView.reloadData()
//        calculateGrandTotal()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUpdate" {
           if let cartFood = sender as? FoodsCart {
                let updateScreen = segue.destination as! UpdateScreen
               updateScreen.cartFood = cartFood
            }
        }
    }


}

extension CartScreen : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartFood = cartList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as! CartTableViewCell
        // Cell data
        cell.foodName.text = "\(cartFood.name!)"
        cell.foodPrice.text = "\(cartFood.price!) ₼"
        let imageUrl = URL(string: "http://kasimadalan.pe.hu/foods/images/\(cartFood.image!)")
        cell.foodImage.kf.setImage(with: imageUrl)
        cell.lblOrderAmount.text = "x \(cartFood.orderAmount!)"
        // Cell design
        cell.cartFoodCellContainer.layer.cornerRadius = 20
        cell.cartFoodCellContainer.layer.borderWidth = 1.5
        cell.cartFoodCellContainer.layer.borderColor = UIColor.lightGray.cgColor
        cell.cartFoodCellContainer.layer.shadowRadius = 10
        cell.cartFoodCellContainer.layer.shadowOffset = .init(width: 0, height: -17)
        cell.cartFoodCellContainer.layer.shadowColor = UIColor.systemOrange.cgColor
        cell.cartFoodCellContainer.layer.shadowOpacity = 0.7
        // Experimental
        cell.cartFoodCellContainer.layer.masksToBounds = false
        cell.cartFoodCellContainer.clipsToBounds = false
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cartFood = cartList[indexPath.row]
        performSegue(withIdentifier: "toUpdate", sender: cartFood)
        tableView.deselectRow(at: indexPath, animated: true )
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let removeAction = UIContextualAction(style: .destructive, title: "remove") {
            (action, view, bool) in
            let cf = self.cartList[indexPath.row]
            let alert = UIAlertController(title: "Confirm Removal", message: "Are you sure you want to delete the following item from the basket? \n\n \(cf.name!)", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { action in
                self.viewModel.delete(cartId: cf.cartId!, userName: self.oruc)
                self.defaultSegmentedControl.selectedSegmentIndex = 0
                print(self.totalSum)
            }

            alert.addAction(confirmAction)
            self.present(alert, animated: true)
            print("\(cf.name!) is Deleted !!!")
            print(self.totalSum)

        }
        
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
    
 }
