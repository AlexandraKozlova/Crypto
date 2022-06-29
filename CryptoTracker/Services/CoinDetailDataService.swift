//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by Aleksandra on 29.06.2022.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDetails: CoinDetail? = nil
    var coinDetailSubscription: AnyCancellable?
    
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        getCoinDetail()
    }
    
    func getCoinDetail() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else { return }
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedCoinDetail in
                self?.coinDetails = returnedCoinDetail
                self?.coinDetailSubscription?.cancel()
            })
    }
}
