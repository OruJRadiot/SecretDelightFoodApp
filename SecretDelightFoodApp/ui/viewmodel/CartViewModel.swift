//
//  CartViewModel.swift
//  SecretDelightFoodApp


import Foundation
import RxSwift

class CartViewModel {
    var cartList = BehaviorSubject<[FoodsCart]>(value: [FoodsCart]())
    var repo = daoRepository()
    var totalSum = BehaviorSubject<Int>(value: 0)
    
    init() {
        
        loadFoodsCart(userName: "oruc_dursunzade")
        cartList = repo.cartList
        totalSum = repo.totalSum
    }
    
    func loadFoodsCart(userName : String){
        repo.loadFoodsCart(userName: userName)
    }
    
    func delete(cartId : Int, userName : String){
        repo.delete(cartId: cartId, userName: userName)
    }
    
    func filterCart (userChoice : Int){
        repo.filterCart(userChoice: userChoice)
    }
}
