//
//  RootView.swift
//  GolfTrackV2
//
//  Created by Stephen Piccone on 2023-03-28.
//

import Combine
import SwiftUI

import SwiftUI

struct RootView: View {
    @StateObject var appState = AppState()
    @State var selectedTab: Tabs = .home
    var wService = weatherService()
    @State var weather: ResponseBody?
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [.blue, .cyan],
                startPoint: .topLeading,
                endPoint: .topTrailing
            )
            .ignoresSafeArea()
            VStack{
                if selectedTab == .home{
                    if let location = appState.currLocation {
                        if let weather = weather {
                            HomeView(weather: weather)
                        } else {
                            //Probably want to switch
                            LoadingView()
                                .task {
                                    do {
                                        weather = try await wService.getCurrentWeather(latitude: location.lat, longitude: location.lon)
                                    } catch {
                                        print("Error getting weather: \(error)")
                                    }
                                }
                        }
                        
                        
                    }
                }
                
                if selectedTab == .records{
                    RecordsView()
                }
                
                
                Spacer()
                
                TabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 0)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    struct RootView_Previews: PreviewProvider {
        static var previews: some View {
            RootView()
        }
    }
    
}
