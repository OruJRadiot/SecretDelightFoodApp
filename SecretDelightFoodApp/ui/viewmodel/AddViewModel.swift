//
//  AddViewModel.swift
//  SecretDelightFoodApp


import Foundation

class AddViewModel {
    var repo = daoRepository()
    
    func add (name: String, image: String, price : Int, category: String, orderAmount: Int, userName : String ) {
        repo.add(name: name, image: image, price: price, category: category, orderAmount: orderAmount, userName: userName)
    }
}
