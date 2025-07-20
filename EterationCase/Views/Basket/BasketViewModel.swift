//
//  BasketViewModel.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 20.07.2025.
//

final class BasketViewModel {
    func getBasketProducts() -> [(Product, Int)] {
        var products = [(Product, Int)]()
        
        for (prd, count) in DataManager.shared.fetchBasket() {
            products.append((prd, Int(count)))
        }
        
        return products
    }
}
