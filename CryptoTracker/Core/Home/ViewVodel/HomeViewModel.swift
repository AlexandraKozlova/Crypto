//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Aleksandra on 09.06.2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    @Published var searchingText = ""
    
    private let dataService = CoinDataService()
    private var cancelleble = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        dataService.$allCoins
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancelleble)
    }
}
