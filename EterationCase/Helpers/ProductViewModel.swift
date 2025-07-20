//
//  ProductViewModel.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 20.07.2025.
//

class ProductViewModel {
    let product: Product
    private(set) var isFavorite: Bool

    init(product: Product) {
        self.product = product
        self.isFavorite = DataManager.shared.fetchFavorites().contains(product)
    }

    func switchFavorite(completion: (Bool) -> Void) {
        if isFavorite {
            DataManager.shared.removeFromFavorites(product: product)
            isFavorite = false
        } else {
            DataManager.shared.addToFavorite(product: product)
            isFavorite = true
        }
        completion(isFavorite)
    }
}
