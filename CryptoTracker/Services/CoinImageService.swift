//
//  CoinImageService.swift
//  CryptoTracker
//
//  Created by Aleksandra on 11.06.2022.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    var imageSubscription: AnyCancellable?
    private var coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        getCoinImages()
    }
    
    private func getCoinImages() {
        guard let url = URL(string: coin.image)
        else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            })
    }
    
}
