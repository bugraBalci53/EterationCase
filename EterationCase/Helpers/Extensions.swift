//
//  Extensions.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 18.07.2025.
//

import UIKit

extension UIImageView {
    func imageFromURL(for urlString: String) {
        guard let imageUrl = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

extension String {
    func addCurrency() -> String {
        return self + " ₺"
    }
}
