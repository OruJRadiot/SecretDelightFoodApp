//
//  daoRepository.swift
//  SecretDelightFoodApp
//
//  Created by Oruj Dursunzade on 23.12.22.
//

import Foundation
import RxSwift
import Alamofire

class daoRepository {
    let oruc : String = "oruc_dursunzade"
    var foodsList = BehaviorSubject<[Foods]>(value: [Foods]())
    var cartList = BehaviorSubject<[FoodsCart]>(value: [FoodsCart]())
    
    var totalSum = BehaviorSubject<Int>(value: 0)

    
    var searchlist = [Foods]()
    var currentCartList = [FoodsCart]()
    var numberOfItems : Int = 0
//    var currentFoodsList = [Foods]()

    func add (name: String, image: String, price : Int, category: String, orderAmount: Int, userName : String ) {
        loadFoodsCart(userName: oruc)
        let duplicateCheck = currentCartList.filter { $0.name!.contains(name)}
        if duplicateCheck.isEmpty {
            let params : Parameters = ["name":name,"image":image,"price":price,"category":category,"orderAmount":orderAmount,"userName":userName]
            AF.request("http://kasimadalan.pe.hu/foods/insertFood.php", method: .post, parameters: params).response { response in
                if let data = response.data {
                    do {
                        let result = try JSONDecoder().decode(CRUDResponse.self, from: data)
                        print("Post result : \(result.success!)")
                        print("Post message : \(result.message!)")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }else{
            
            for food in duplicateCheck {
                delete(cartId: food.cartId!, userName: oruc)
                let params : Parameters = ["name":name,"image":image,"price":price,"category":category,"orderAmount":(food.orderAmount! + orderAmount),"userName":userName]
                AF.request("http://kasimadalan.pe.hu/foods/insertFood.php", method: .post, parameters: params).response { response in
                    if let data = response.data {
                        do {
                            let result = try JSONDecoder().decode(CRUDResponse.self, from: data)
                            print("Post result : \(result.success!)")
                            print("Post message : \(result.message!)")
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            
        }
    }
    
    func update (cartId: Int, name: String, image: String, price : Int, category: String, orderAmount: Int, userName : String ) {
        add(name: name, image: image, price: price, category: category, orderAmount: orderAmount, userName: userName)
        delete(cartId: cartId, userName: userName)
        loadFoodsCart(userName: oruc)
//        print("Item added to the cart : \n cartId: \(cartId)\n name: \(name)\n price: \(price)\n category: \(category)\n orderAmount: \(orderAmount)\n userName: \(userName)")
    }
    
    func loadFoods () {
        AF.request("http://kasimadalan.pe.hu/foods/getAllFoods.php", method: .get).response { response in
            if let data = response.data {
                do {
                    let result = try JSONDecoder().decode(FoodsResponse.self, from: data)
                    if let list = result.foods {
                        self.foodsList.onNext(list)
                        self.searchlist = list
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func loadFoodsCart (userName : String) {
        let params : Parameters = ["userName":userName]
        
        AF.request("http://kasimadalan.pe.hu/foods/getFoodsCart.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let result = try JSONDecoder().decode(FoodsCartResponse.self, from: data)
                    if let list = result.foods_cart {
                        self.cartList.onNext(list)
                        self.currentCartList = list
                        self.numberOfItems = list.count
                        
                        var grandTotal : Int = 0
                        list.forEach({ cartFood in
                            if let price = cartFood.price, let amount = cartFood.orderAmount {
                                let result = price * amount
                                grandTotal += result
                            }
                        })
                        self.totalSum.onNext(grandTotal)
                    }
                } catch {
                    print(error.localizedDescription)
//                    self.cartList.onNext([])
//                    self.currentCartList = []
                }
            }
        }
    }
    
    func search(searchText : String){
        if searchText.trimmingCharacters(in: .whitespaces) == "" {
            loadFoods()
        }else{
            let filtered = searchlist.filter { $0.name!.contains(searchText) }
            self.foodsList.onNext(filtered)
        }
    }
    
    func delete (cartId: Int, userName : String){
        let params : Parameters = ["cartId":cartId,"userName":userName]
        
        AF.request("http://kasimadalan.pe.hu/foods/deleteFood.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let result = try JSONDecoder().decode(CRUDResponse.self, from: data)
                    print("Post result : \(result.success!)")
                    print("Post message : \(result.message!)")
                    if self.currentCartList.count > 1 {
                        self.loadFoodsCart(userName: userName)
                    } else if self.currentCartList.count == 1{
                        self.cartList.onNext([])
                        self.totalSum.onNext(0)
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func filterCart (userChoice : Int) {
        var filteredList = currentCartList
        if userChoice == 0{
            self.cartList.onNext(currentCartList)
        }else if userChoice == 1{
            filteredList = currentCartList.filter { $0.category!.contains("Meals") }
            self.cartList.onNext(filteredList)
        }
        else if userChoice == 2{
            filteredList = currentCartList.filter { $0.category!.contains("Drinks") }
            self.cartList.onNext(filteredList)
        }
        else if userChoice == 3{
            filteredList = currentCartList.filter { $0.category!.contains("Desserts") }
            self.cartList.onNext(filteredList)
        }
    }
    
    func userCategorySelector (category : Int) {
        var filteredList = searchlist
        if category == 0{
            self.foodsList.onNext(searchlist)
        }else if category == 1{
            filteredList = searchlist.filter { $0.category!.contains("Meals") }
            self.foodsList.onNext(filteredList)
        }
        else if category == 2{
            filteredList = searchlist.filter { $0.category!.contains("Drinks") }
            self.foodsList.onNext(filteredList)
        }
        else if category == 3{
            filteredList = searchlist.filter { $0.category!.contains("Desserts") }
            self.foodsList.onNext(filteredList)
        }
    }
    

}
