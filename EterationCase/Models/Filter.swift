//
//  Filter.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 19.07.2025.
//

enum SortingType {
    case dateOldToNew
    case dateNewToOld
    case priceHighToLow
    case priceLowToHigh
}

enum FilterType {
    case sorting
    case brand
    case model
    
    var title: String {
        switch self {
        case .brand:
            return "Brand"
        case .model:
            return "Model"
        case .sorting:
            return "Sort By"
        }
    }
}

struct FilterSection {
    let type: FilterType
    var filters: [Filter]
    let searchable: Bool
    let multipleSelection: Bool
}

struct Filter {
    let name: String
    var isSelected: Bool = false
    var sortFilterType: SortingType? = nil
}
