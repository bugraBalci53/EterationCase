//
//  Tools.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 21.07.2025.
//

import Foundation

class Tools {
    func getData(name: String, withExtension: String = "json") -> Data {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
        let data = try! Data(contentsOf: fileUrl!)
        return data
    }
}
