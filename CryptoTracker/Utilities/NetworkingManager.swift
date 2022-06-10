//
//  NetworkingManager.swift
//  CryptoTracker
//
//  Created by Aleksandra on 10.06.2022.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badUrlResponse(url: URL)
        case unknow
        
        var errorDescription: String? {
            switch self {
            case .badUrlResponse(url: let url):
                return "Bad response from URL: \(url)"
            case .unknow:
                return "Unknow error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap( { try handleUrlResponce(output: $0, url: url) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleUrlResponce(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let responce = output.response as? HTTPURLResponse,
              responce.statusCode >= 200 && responce.statusCode < 300 else {
                  throw NetworkingError.badUrlResponse(url: url)
              }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription, "bad")
        }
    }
}
