//
//  String.swift
//  CryptoTracker
//
//  Created by Aleksandra on 06.07.2022.
//

import Foundation

extension String {
    
    var removingHTLMOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
