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
    
    private var imageSubscription: AnyCancellable?
    private var coin: Coin
    private let fileManager = LocalFileManager.shared
    private let folderName = "coin_images"
    
    init(coin: Coin) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: coin.id, foldeerName: folderName) {
            image = savedImage
        } else {
            downloadCoinImages()
        }
    }
    
    private func downloadCoinImages() {
        guard let url = URL(string: coin.image)
        else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard let self = self, let returnedImage = returnedImage else { return }
                self.image = returnedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImages(image: returnedImage, imageName: self.coin.id, folderName: self.folderName)
            })
    }
    
}
