//
//  ListViewModel.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 18.07.2025.
//
import Foundation

final class ListViewModel {
    let network = NetworkManager()
    let isoFormatter = ISO8601DateFormatter()
    
    var safeProducts = [Product]()
    
    func fetchProducts() async -> Result<[Product], NetworkError>{
        do {
            let products = try await network.request(model: RequestModel(urlString: "https://5fc9346b2af77700165ae514.mockapi.io/products", method: .get, dataModel: [Product].self))
            safeProducts = products
            return .success(products)
        } catch {
            guard let networkError = error as? NetworkError else { return .failure(.unknown(message: "Somethink went wrong!")) }
            
            return .failure(networkError)
        }
    }
    
    func filteredProducts(filters: [FilterSection]) -> [Product] {
        var filteredSet = Set<Product>()

        
        for section in filters {
            switch section.type {
            case .sorting:
                continue
            case .brand:
                for filter in section.filters where filter.isSelected {
                    let matched = safeProducts.filter { $0.brand == filter.name }
                    filteredSet.formUnion(matched)
                }
            case .model:
                for filter in section.filters where filter.isSelected {
                    let matched = safeProducts.filter { $0.model == filter.name }
                    filteredSet.formUnion(matched)
                }
            }
        }

        var finalProducts: [Product] = filteredSet.isEmpty ? safeProducts : Array(filteredSet)

        if let sortSection = filters.first(where: { $0.type == .sorting }),
           let selectedSort = sortSection.filters.first(where: { $0.isSelected }) {

            switch selectedSort.sortFilterType {
            case .dateOldToNew:
                finalProducts.sort {
                    let date0 = isoFormatter.date(from: $0.createdAt ?? "") ?? .distantPast
                    let date1 = isoFormatter.date(from: $1.createdAt ?? "") ?? .distantPast
                    return date0 < date1
                }
            case .dateNewToOld:
                finalProducts.sort {
                    let date0 = isoFormatter.date(from: $0.createdAt ?? "") ?? .distantPast
                    let date1 = isoFormatter.date(from: $1.createdAt ?? "") ?? .distantPast
                    return date0 > date1
                }
            case .priceLowToHigh:
                finalProducts.sort {
                    let price0 = Double($0.price ?? "") ?? 0
                    let price1 = Double($1.price ?? "") ?? 0
                    return price0 < price1
                }
            case .priceHighToLow:
                finalProducts.sort {
                    let price0 = Double($0.price ?? "") ?? 0
                    let price1 = Double($1.price ?? "") ?? 0
                    return price0 > price1
                }
            case .none:
                break
            }
        }

        return finalProducts
    }

}
