//
//  DataManager.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 20.07.2025.
//

import CoreData

class DataManager {
    static let shared = DataManager()
    
    private init() { }
    

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EterationCase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addToFavorite(product: Product) {
        let context = persistentContainer.viewContext
        let favProduct = ProductEntity(context: context)
        
        favProduct.id = product.id ?? ""
        
        if let productData = try? JSONEncoder().encode(product) {
            favProduct.product = productData
        }
        
        saveContext()
    }

    func removeFromFavorites(product: Product) {
        guard let productID = product.id else { return }
        
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productID)
        fetchRequest.fetchLimit = 1

        do {
            if let toDelete = try context.fetch(fetchRequest).first {
                context.delete(toDelete)
                saveContext()
            }
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
    
    func dataToProduct(productData: Data?) -> Product? {
        guard let favProduct = productData else { return nil }
        
        let decodedProduct = try? JSONDecoder().decode(Product.self, from: favProduct)
        return decodedProduct
    }
    
    func fetchFavorites() -> [Product] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            return results.compactMap { dataToProduct(productData: $0.product) }
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func addToBasket(product: Product, count: Int) {
        guard let productID = product.id else { return }
        
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BasketEntity> = BasketEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productID)
        fetchRequest.fetchLimit = 1
        
        do {
            if let existingItem = try context.fetch(fetchRequest).first {
                existingItem.count += Int16(count)
            } else {
                let basketProduct = BasketEntity(context: context)
                basketProduct.id = productID
                if let productData = try? JSONEncoder().encode(product) {
                    basketProduct.product = productData
                }
                basketProduct.count = Int16(count)
            }

            saveContext()
            NotificationCenter.default.post(name: .basketUpdated, object: nil)
            
        } catch {
            print("Basket fetch error: \(error)")
        }
    }
    
    func removeFromBasket(product: Product) {
        guard let productID = product.id else { return }

        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BasketEntity> = BasketEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productID)
        fetchRequest.fetchLimit = 1

        do {
            if let existingItem = try context.fetch(fetchRequest).first {
                if existingItem.count > 1 {
                    existingItem.count -= 1
                } else {
                    context.delete(existingItem)
                }
                saveContext()
                NotificationCenter.default.post(name: .basketUpdated, object: nil)
            }
        } catch {
            print("Basket decrease error: \(error)")
        }
    }
    
    func fetchBasket() -> [(Product, Int16)] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BasketEntity> = BasketEntity.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            return results.compactMap {
                guard let product = dataToProduct(productData: $0.product) else { return nil }
                return (product, $0.count)
            }
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func totalBasketItemCount() -> Int {
        let basketItems = DataManager.shared.fetchBasket()
        let totalCount = basketItems.reduce(0) { partialResult, item in
            partialResult + (Int(item.1))
        }
        return totalCount
    }
    
    func getBasketTotal() -> Double {
        let basketItems = DataManager.shared.fetchBasket()
        
        let total = basketItems.reduce(0.0) { result, item in
            let (product, count) = item
            
            guard let price = Double(product.price?.replacingOccurrences(of: ",", with: ".") ?? "0") else {
                return result
            }
            
            return result + (Double(count) * price)
        }
        
        return total
    }
}
