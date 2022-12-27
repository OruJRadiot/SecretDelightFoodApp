//
//  HomeViewModel.swift
//  SecretDelightFoodApp


import Foundation
import RxSwift

class HomeViewModel {
    var foodsList = BehaviorSubject<[Foods]>(value: [Foods]())
    
    var repo = daoRepository()
    
    init() {
        loadFoods()
        foodsList = repo.foodsList
    }
    
    func loadFoods(){
        repo.loadFoods()
    }
    
    func search(searchText : String){
        repo.search(searchText: searchText)
    }
    
    func userCategorySelector(category : Int) {
        repo.userCategorySelector(category: category)
    }
}
