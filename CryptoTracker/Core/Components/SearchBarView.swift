//
//  SearchBarView.swift
//  CryptoTracker
//
//  Created by Aleksandra on 14.06.2022.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchingText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchingText.isEmpty ?
                    Color.theme.secondaryText : Color.theme.accent
                )
            TextField("Search by name or symbol", text: $searchingText)
                .foregroundColor(Color.theme.accent)
                .disableAutocorrection(true)
                .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .offset(x: 10)
                    .foregroundColor(Color.theme.accent)
                    .opacity(searchingText.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        searchingText = ""
                    }
                ,alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.15),
                        radius: 10, x: 0, y: 0)
        )
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchingText: .constant(""))
            .preferredColorScheme(.dark)
    }
}
