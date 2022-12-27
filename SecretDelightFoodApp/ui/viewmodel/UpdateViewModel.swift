//
//  UpdateViewModel.swift
//  SecretDelightFoodApp


import Foundation

class UpdateViewModel {
    var repo = daoRepository()
    
    func update (cartId: Int, name: String, image: String, price : Int, category: String, orderAmount: Int, userName : String ) {
        repo.update(cartId: cartId, name: name, image: image, price: price, category: category, orderAmount: orderAmount, userName: userName)
    }
    
    func loadFoodsCart(userName : String){
        repo.loadFoodsCart(userName: userName)
    }
}
