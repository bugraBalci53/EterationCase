//
//  NetworkManager.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 18.07.2025.
//
import Foundation

enum Method: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case requestError(message: String)
    case responseError(message: String)
    case decodeError(message: String)
    case unknown(message: String)
}

struct RequestModel<T: Codable> {
    let urlString: String
    let method: Method
    let dataModel: T.Type
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
}

struct NetworkManager {
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func request<T: Codable>(model: RequestModel<T>) async throws -> T {
        guard let request = model.urlRequest else {
            throw NetworkError.requestError(message: "Check the url!")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.requestError(message: "Something went wrong! Please check the response.")
            }
            
            guard let decodedData = try? decoder.decode(T.self, from: data) else {
                throw NetworkError.decodeError(message: "Response can not decoded.")
            }
            
            return decodedData
        } catch {
            throw NetworkError.unknown(message: "Something went wrong!")
        }
    }
}
