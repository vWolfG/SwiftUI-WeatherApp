//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Veronika Goreva on 12/21/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.init("LightBlue")]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Krasnoyarsk")
                    .font(.system(size: 32, weight: .medium, design: .default))
                    .foregroundColor(.white)
                    .padding(.bottom)
                VStack(spacing: 8) {
                    Image(systemName: "cloud.sun.fill")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 180)
                    Text("-15°")
                        .font(.system(size: 70, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 40)
                HStack(spacing: 10) {
                    WeatherDayView(dayOfWeek: "MON", imageName: "cloud.sun.fill", temperature: -5)
                    WeatherDayView(dayOfWeek: "TUE", imageName: "cloud.moon.rain.fill", temperature: -14)
                    WeatherDayView(dayOfWeek: "WED", imageName: "cloud.snow.fill", temperature: -11)
                    WeatherDayView(dayOfWeek: "THU", imageName: "cloud.sun.fill", temperature: -8)
                    WeatherDayView(dayOfWeek: "FRI", imageName: "cloud.hail.fill", temperature: -15)
                    
                }
                Spacer()
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WeatherDayView: View {
    var dayOfWeek: String
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text(dayOfWeek)
                .font(.system(size: 16.0, weight: .medium, design: .rounded))
                .foregroundColor(.white)
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
//                .foregroundColor(.white)
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(temperature)°")
                .font(.system(size: 24.0, weight: .medium, design: .rounded))
                .foregroundColor(.white)
            
        }
    }
}
