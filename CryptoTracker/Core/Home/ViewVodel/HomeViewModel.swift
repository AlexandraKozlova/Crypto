//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Aleksandra on 09.06.2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistic: [Statistic] = [
        Statistic(title: "Title", value: "Value", percentageChange: 1),
        Statistic(title: "Title", value: "Value"),
        Statistic(title: "Title", value: "Value"),
        Statistic(title: "Title", value: "Value", percentageChange: -7)
        ]
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    @Published var searchingText = ""
    
    private let dataService = CoinDataService()
    private var cancelleble = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $searchingText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { (text, startingCoins) ->  [Coin] in
                
                guard !text.isEmpty else {
                    return startingCoins
                }
                let lowercasedText = text.lowercased()
                return startingCoins.filter { coin in
                    return coin.name.lowercased().contains(lowercasedText) ||
                           coin.symbol.lowercased().contains(lowercasedText) ||
                           coin.id.lowercased().contains(lowercasedText)
                }
            }
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancelleble)
    }
}
