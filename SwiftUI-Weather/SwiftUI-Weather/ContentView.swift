//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Veronika Goreva on 12/21/20.
//

import SwiftUI

struct WeatherDayModel {
    let dayOfWeek: String
    let temperature: Int
    let imageString: String
}

struct ContentView: View {
    @State private var isNight = false
    @State private var currentWeather: CurrentWeather?
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: $isNight)
            VStack {
                CityTextView(cityName: currentWeather?.name ?? "Krasnoyarsk")
                MainWeatherStatusView(imageName: isNight ? "moon.stars.fill" : "cloud.sun.fill",
                                      temperature: Int(currentWeather?.main.temp ?? -15))
                HStack(spacing: 10) {
                    WeatherDayView(dayOfWeek: "MON", imageName: "cloud.sun.fill", temperature: -5)
                    WeatherDayView(dayOfWeek: "TUE", imageName: "cloud.moon.rain.fill", temperature: -14)
                    WeatherDayView(dayOfWeek: "WED", imageName: "cloud.snow.fill", temperature: -11)
                    WeatherDayView(dayOfWeek: "THU", imageName: "cloud.sun.fill", temperature: -8)
                    WeatherDayView(dayOfWeek: "FRI", imageName: "cloud.hail.fill", temperature: -15)
                    
                }
                Spacer()
        
                Button {
                    isNight.toggle()
                } label: {
                    WeatherButton(title: "Change Day Time",
                                  backgroundColor: Color.white,
                                  textColor: Color.blue)
                }
                Spacer()
            } .onAppear {
                NetworkManager().requestDecoded(WeatherTarget.currentWeather,
                                                to: CurrentWeather.self) { (result) in
                    switch result {
                    case let .success(currentWeather):
                        self.currentWeather = currentWeather
                    case let .failure(error):
                        debugPrint(error.localizedDescription)
                    }
                }
            }
            
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(currentWeather: CurrentWeather(weather: <#T##[Weather]#>, main: <#T##MainWeatherInfo#>, coord: <#T##Coordinate#>, name: <#T##String#>))
//    }
//}

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
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(temperature)°")
                .font(.system(size: 24.0, weight: .medium, design: .rounded))
                .foregroundColor(.white)
            
        }
    }
}

struct BackgroundView: View {
    @Binding var isNight: Bool
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [isNight ? Color.black :  Color.blue,
                                                   isNight ? Color.gray : Color.init("LightBlue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CityTextView: View {
    var cityName: String
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding(.bottom)
    }
}


struct MainWeatherStatusView: View {
    var imageName: String
    var temperature: Int
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium, design: .rounded))
                .foregroundColor(.white)
        }
        .padding(.bottom, 40)
    }
}
