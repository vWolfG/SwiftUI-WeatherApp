//
//  WeatherButton.swift
//  SwiftUI-Weather
//
//  Created by Veronika Goreva on 12/21/20.
//

import SwiftUI

struct WeatherButton: View {
    var title: String
    var backgroundColor: Color
    var textColor: Color
    var body: some View {
        Text(title)
            .frame(width: 280, height: 50)
            .background(backgroundColor)
            .font(.system(size: 20, weight: .bold, design: .default))
            .foregroundColor(textColor)
            .cornerRadius(10)
    }
}
