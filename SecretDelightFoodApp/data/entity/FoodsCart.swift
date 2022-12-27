//
//  FoodsCart.swift
//  SecretDelightFoodApp
//
//  Created by Oruj Dursunzade on 22.12.22.
//

import Foundation

class FoodsCart : Codable{
    var cartId : Int?
    var name : String?
    var image : String?
    var price : Int?
    var category : String?
    var orderAmount : Int?
    var userName : String?
    
    init(cartId: Int, name: String, image: String, price: Int, category: String, orderAmount: Int, userName: String) {
        self.cartId = cartId
        self.name = name
        self.image = image
        self.price = price
        self.category = category
        self.orderAmount = orderAmount
        self.userName = userName
    }

}


//class FoodsCart : Foods {
//    var cartId : Int?
//    var orderAmount : Int?
//    var userName : String = "Oruc Dursunzade"
//
//    init(cartId: Int, orderAmount: Int, id: Int, name: String, image: String, price: Int, category: String) {
//        self.cartId = cartId
//        self.orderAmount = orderAmount
////        self.userName = userName
//        super.init(id: id, name: name, image: image, price: price, category: category)
//    }
//}
