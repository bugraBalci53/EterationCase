//
//  FilterViewModel.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 19.07.2025.
//

final class FilterViewModel {
    func getFilterSections(products: [Product], selectedSections: [FilterSection]) -> [FilterSection] {
        var filterTypes = [FilterSection]()
        
        let uniqueBrands = Set(products.compactMap { $0.brand?.trimmingCharacters(in: .whitespacesAndNewlines) })
        let uniqueModels = Set(products.compactMap { $0.model?.trimmingCharacters(in: .whitespacesAndNewlines) })

        let brandFilters = uniqueBrands.map { Filter(name: $0) }
        let modelFilters = uniqueModels.map { Filter(name: $0) }

        let sortFilters = [
            Filter(name: "Old To New", sortFilterType: .dateOldToNew),
            Filter(name: "New To Old", sortFilterType: .dateNewToOld),
            Filter(name: "Price High To Low", sortFilterType: .priceHighToLow),
            Filter(name: "Price Low To High", sortFilterType: .priceLowToHigh)
        ]

        filterTypes.append(FilterSection(type: .sorting, filters: sortFilters, searchable: false, multipleSelection: false))
        filterTypes.append(FilterSection(type: .brand, filters: brandFilters, searchable: true, multipleSelection: true))
        filterTypes.append(FilterSection(type: .model, filters: modelFilters, searchable: true, multipleSelection: true))

        return filterTypes
    }
}
