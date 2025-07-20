//
//  EterationCaseTests.swift
//  EterationCaseTests
//
//  Created by Mehmet Buğra BALCI on 18.07.2025.
//

import XCTest
@testable import EterationCase

final class ListViewModelTests: XCTestCase {
    
    var viewModel: ListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ListViewModel()
        
        guard let products = try? JSONDecoder().decode([Product].self, from: Tools().getData(name: "productList")) else {
            XCTFail("Failed to load productList data")
            return
        }
        viewModel.safeProducts = products
    }
    
    func testAllProducts() {
        let filtered = viewModel.filteredProducts(filters: [])
        XCTAssertEqual(filtered.count, viewModel.safeProducts.count, "Filtering with no filters should return all products")
    }
    
    func testBrandFilter() {
        let filter = Filter(name: "Lamborghini", isSelected: true)
        let section = FilterSection(type: .brand, filters: [filter], searchable: false, multipleSelection: false)
        
        let filtered = viewModel.filteredProducts(filters: [section])
        
        XCTAssertFalse(filtered.isEmpty, "Filtered list should not be empty for brand Lamborghini")
        XCTAssertTrue(filtered.allSatisfy { $0.brand == "Lamborghini" }, "All products should have brand Lamborghini")
    }
    
    func testModelFilter() {
        let filter = Filter(name: "CTS", isSelected: true)
        let section = FilterSection(type: .model, filters: [filter], searchable: false, multipleSelection: false)
        
        let filtered = viewModel.filteredProducts(filters: [section])
        
        XCTAssertFalse(filtered.isEmpty, "Filtered list should not be empty for model CTS")
        XCTAssertTrue(filtered.allSatisfy { $0.model == "CTS" }, "All products should have model CTS")
    }
    
    func testSortByDateNewToOld() {
        let sortFilter = Filter(name: "Newest", isSelected: true, sortFilterType: .dateNewToOld)
        let section = FilterSection(type: .sorting, filters: [sortFilter], searchable: false, multipleSelection: false)
        
        let filtered = viewModel.filteredProducts(filters: [section])
        
        let dates = filtered.compactMap { viewModel.isoFormatter.date(from: $0.createdAt ?? "") }
        let sortedDates = dates.sorted(by: >)
        
        XCTAssertEqual(dates, sortedDates, "Products should be sorted from newest to oldest")
    }
    
    func testSortByPriceLowToHigh() {
        let sortFilter = Filter(name: "Price Low to High", isSelected: true, sortFilterType: .priceLowToHigh)
        let section = FilterSection(type: .sorting, filters: [sortFilter], searchable: false, multipleSelection: false)
        
        let filtered = viewModel.filteredProducts(filters: [section])
        
        let prices = filtered.compactMap { Double($0.price ?? "0") }
        for i in 1..<prices.count {
            XCTAssertLessThanOrEqual(prices[i-1], prices[i], "Prices should be sorted ascending")
        }
    }
}
