//
//  ViewController.swift
//  SecretDelightFoodApp
//
//  Created by Oruj Dursunzade on 12.12.22.
//

import UIKit
import RxSwift
import Kingfisher

class HomeScreen: UIViewController {
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var categoriesContainer: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableHeader: UILabel!
    
    @IBOutlet weak var foodsTableView: UITableView!
    
    var foodsList = [Foods]()
    var viewModel = HomeViewModel()
    var cartViewModel = CartViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
        foodsTableView.delegate = self
        foodsTableView.dataSource = self
        
        // SEARCH FIELD DESIGN
        searchField.searchTextField.leftView?.tintColor = UIColor(named: "text-primary")
        searchField.placeholder = "Search your favourite delights"
        searchField.searchTextField.backgroundColor = UIColor(named: "bg-lower-opacity")
        
        categoriesContainer.layer.cornerRadius = 30.0
        categoriesContainer.backgroundColor = UIColor(named: "bg-low-opacity")
        
        
        // Tab Bar & Navigation DESIGN
        
        // TABBAR CONTROLLER
        if let tabBarItems = tabBarController?.tabBar.items {
            let homeTab = tabBarItems[0]
            let cartTab = tabBarItems[1]
            homeTab.badgeValue = "welcome!"
            cartTab.badgeValue = "*"
        }
        let tabBarApperance = UITabBarAppearance()
        tabBarApperance.backgroundColor = UIColor(named: "bg-component")
        
        tabBarItemsCustomColor(itemAppearance: tabBarApperance.stackedLayoutAppearance)
        tabBarItemsCustomColor(itemAppearance: tabBarApperance.inlineLayoutAppearance)
        tabBarItemsCustomColor(itemAppearance: tabBarApperance.compactInlineLayoutAppearance)
        
        tabBarController?.tabBar.standardAppearance = tabBarApperance
        tabBarController?.tabBar.scrollEdgeAppearance = tabBarApperance
        
        func tabBarItemsCustomColor (itemAppearance : UITabBarItemAppearance){
            itemAppearance.selected.iconColor = UIColor(named: "text-primary")
            itemAppearance.selected.titleTextAttributes = [.foregroundColor : UIColor(named: "text-primary")!]
            itemAppearance.selected.badgeBackgroundColor = UIColor.red
            itemAppearance.normal.iconColor = UIColor.white
            itemAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.white]
            itemAppearance.normal.badgeBackgroundColor = UIColor.red
        }
        
        // NAVIGATION CONTROLLER
        let navigationBarApperance = UINavigationBarAppearance()
        navigationBarApperance.backgroundColor = UIColor(named: "bg-component")
        navigationBarApperance.titleTextAttributes = [.foregroundColor : UIColor(named: "text-primary")!, .font : UIFont(name: "Papyrus", size: 30)!]

        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.standardAppearance = navigationBarApperance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarApperance
        navigationController?.navigationBar.compactAppearance = navigationBarApperance
        
        
        // WORKING WITH DATA

        _ = viewModel.foodsList.subscribe(onNext: { list in
            self.foodsList = list
            DispatchQueue.main.async {
                self.foodsTableView .reloadData()
            }
        })
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
           if let food = sender as? Foods {
                let addScreen = segue.destination as! AddScreen
                addScreen.food = food
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    @IBAction func btnMeals(_ sender: Any) {
        userCategorySelector(category: 1)
        self.foodsTableView.reloadData()
        tableHeader.text = "Meals"
    }
    
    @IBAction func btnDesserts(_ sender: Any) {
        userCategorySelector(category: 3)
        self.foodsTableView.reloadData()
        tableHeader.text = "Desserts"
    }
    
    @IBAction func btnDrinks(_ sender: Any) {
        userCategorySelector(category: 2)
        self.foodsTableView.reloadData()
        tableHeader.text = "Drinks"
    }
    
    @IBAction func btnSeeAll(_ sender: Any) {
        userCategorySelector(category: 0)
        self.foodsTableView.reloadData()
        tableHeader.text = "Our Menu"
    }
    
    func userCategorySelector (category : Int){
        viewModel.userCategorySelector(category: category)
    }
    

}


// EXTENSIONS
 
extension HomeScreen : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespaces) == "" {
            viewModel.userCategorySelector(category: 0)
            self.foodsTableView.reloadData()
            self.tableHeader.text = "Our Menu"
        } else {
            self.tableHeader.text = "Results for : \(searchText)"
            viewModel.search(searchText: searchText)
            self.foodsTableView.reloadData()
        }
        
        
    }
}


extension HomeScreen : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let food = foodsList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell") as! FoodTableViewCell
        cell.foodName.text = "\(food.name!)"
        cell.foodPrice.text = "\(food.price!) ₼"
        let imageUrl = URL(string: "http://kasimadalan.pe.hu/foods/images/\(food.image!)")
        cell.foodImage.kf.setImage(with: imageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = foodsList[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: food)
        tableView.deselectRow(at: indexPath, animated: true )
    }
    
}





