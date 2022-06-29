//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Aleksandra on 29.06.2022.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .sink { coinDetail in
                print(coinDetail)
            }
            .store(in: &cancellables)
    }
}
