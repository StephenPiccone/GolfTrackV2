//
//  HomeView.swift
//  GolfTrackV2
//
//  Created by Stephen Piccone on 2023-03-28.
//

import Combine
import SwiftUI
import CoreData

struct HomeView: View {
    @StateObject var appState = AppState()
    @State private var startLocationSet = false
    @State private var selectedClub = "Driver"
    @State var selectedTab: Tabs = .home
    @State var weather: ResponseBody
    
    @Environment (\.managedObjectContext) var managedObjectContext
    var clubs = ["Driver", "3W", "5W", "7W", "3H", "4H", "1i", "2i", "3i", "4i", "5i", "6i", "7i", "8i", "9i", "PW", "SW", "GW", "LW"]
    
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var shot: FetchedResults<Shot>
    
    
    var body: some View {
        ZStack{
            
            VStack(alignment: .center, spacing: 4){
                if startLocationSet {
                    Button(
                        action: {appState.userEndLocation()
                            startLocationSet.toggle()
                            appState.pointDistance()
                            let newShot = Shot(context: self.managedObjectContext)
                            newShot.date = Date()
                            newShot.id = UUID()
                            newShot.distance = appState.shotDistance_yards
                            newShot.club = selectedClub
                            do {
                                try self.managedObjectContext.save()
                            }
                            catch{
                                //Update this for user to see
                                print("Data not saved")
                            }
                            
                        },
                        label:
                            {
                                HStack{
                                    VStack{
                                        Text("\(appState.shotDistance_yards, specifier: "%.0f")")
                                            .font(.system(size: 60))
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                        Text("YDS")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                            .fontWeight(.light)
                                    }
                                    Spacer()
                                    Text("Stop")
                                        .font(.system(size: 100))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                }
                            } )
                    .buttonStyle(GrowingButton())
                    .padding(.top, 80)
                }
                else
                {
                    Button(
                        action: {appState.userStartLocation()
                            startLocationSet.toggle()
                            
                        },
                        label:
                            {
                                HStack{
                                    VStack{
                                        Text("\(appState.shotDistance_yards, specifier: "%.0f")")
                                            .font(.system(size: 60))
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                        Text("YDS")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                            .fontWeight(.light)
                                    }
                                    Spacer()
                                    Text("Start")
                                        .font(.system(size: 100))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                }
                            } )
                    .buttonStyle(GrowingButton())
                    .padding(.top, 80)
                }
                
                Spacer()
                
            }
            
            VStack{
                Spacer()
                VStack(alignment: .leading){
                    
                    Text("Info")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                    HStack(spacing: 20){
                        
                        Image(systemName: "figure.golf")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                            .frame(width: 20, height: 20)
                            .padding()
                            .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                            .cornerRadius(50)
                        
                        Text("Selected Club:")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                        //.padding()
                        
                        Menu {
                            Picker("Selected Club:", selection: $selectedClub){
                                ForEach(clubs, id: \.self){
                                    Text($0)
                                    
                                }
                            }
                        } label: {
                            Text(selectedClub)
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                            //.padding()
                                .fontWeight(.semibold)
                            
                        }
                        
                        
                        
                        
                    }
                    
                    HStack{
                        HStack(spacing: 20){
                            
                            Image(systemName: "wind")
                            //.rotationEffect(.degrees(weather.wind.deg))
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                            //.font(.title2)
                                .frame(width: 20, height: 20)
                                .padding()
                                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                                .cornerRadius(50)
                            //.padding()
                            VStack(alignment: .leading, spacing: 8){
                                Text("Wind speed")
                                    .font(.system(size: 12))
                                    .foregroundColor(.blue)
                                
                                Text("\(weather.wind.speed, specifier: "%.0f") m/s")
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                                    .fontWeight(.bold)
                            }
                            
                            
                            
                        }
                        Spacer()
                        
                        HStack(spacing: 20){
                            
                            Image(systemName: "thermometer.medium")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                                .frame(width: 20, height: 20)
                                .padding()
                                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                                .cornerRadius(50)
                            VStack(alignment: .leading, spacing: 8){
                                Text("Current temp")
                                    .font(.system(size: 12))
                                    .foregroundColor(.blue)
                                
                                Text("\(weather.main.feelsLike, specifier: "%.0f") °C")
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                                    .fontWeight(.bold)
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    HStack{
                        HStack(spacing: 20){
                            var headTail = appState.headOrTail(windDirection: weather.wind.deg)
                            var windChange = appState.windEffect(headOrTail: headTail, windSpeed: weather.wind.speed)
                            
                            if headTail == true {
                                Image(systemName: "arrow.up.circle")
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                                    .frame(width: 20, height: 20)
                                    .padding()
                                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                                    .cornerRadius(50)
                                VStack(alignment: .leading, spacing: 8){
                                    Text("Wind effect on ball")
                                        .font(.system(size: 12))
                                        .foregroundColor(.blue)
                                    
                                    Text("+\(windChange, specifier: "%.1f") %")
                                        .font(.system(size: 30))
                                        .foregroundColor(.green)
                                        .fontWeight(.bold)
                                }
                            }else{
                                Image(systemName: "arrow.down.circle")
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                                    .frame(width: 20, height: 20)
                                    .padding()
                                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                                    .cornerRadius(50)
                                VStack(alignment: .leading, spacing: 8){
                                    Text("Wind effect on ball")
                                        .font(.system(size: 12))
                                        .foregroundColor(.blue)
                                    
                                    Text("-\(windChange, specifier: "%.1f") %")
                                        .font(.system(size: 30))
                                        .foregroundColor(.red)
                                        .fontWeight(.bold)
                                }
                            }
                            
                            
                            
                            
                            
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 20){
                            if shot.isEmpty{
                                
                                Image(systemName: "ruler")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                                .frame(width: 20, height: 20)
                                .padding()
                                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                                .cornerRadius(50)
                                VStack(alignment: .leading, spacing: 8){
                                    Text("Last shot")
                                        .font(.system(size: 12))
                                        .foregroundColor(.blue)
                                    
                                    Text("N/A")
                                        .font(.system(size: 30))
                                        .foregroundColor(.blue)
                                        .fontWeight(.bold)
                                }
                                
                            }else{
                                Image(systemName: "ruler")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                                .frame(width: 20, height: 20)
                                .padding()
                                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                                .cornerRadius(50)
                                VStack(alignment: .leading, spacing: 8){
                                    Text("Last shot")
                                        .font(.system(size: 12))
                                        .foregroundColor(.blue)
                                    
                                    Text("\(shot[0].distance, specifier: "%.0f")")
                                        .font(.system(size: 30))
                                        .foregroundColor(.blue)
                                        .fontWeight(.bold) +
                                    Text("Yds")
                                        .font(.system(size: 15))
                                        .foregroundColor(.blue)
                                        .fontWeight(.light)
                                }
                        }
                            
                            
                            
                        }
                        
                    }
                    
                    
                    
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .background(.white)
                .cornerRadius(20, corners: [.allCorners])
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(.dark)
        
        
    }
}






struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(weather: previewWeather)
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

