//
//  AppState.swift
//  GolfTrackV2
//
//  Created by Stephen Piccone on 2023-03-28.
//

import Combine
import Foundation


class AppState: ObservableObject
{
    var deviceLocationService = DeviceLocationService.shared
    let EARTH_RAD_KM = 6371.0
    @Published var currLocation:(lat: Double, lon: Double) = (0.0,0.0)
    @Published var startUserLocation: (lat: Double, lon: Double) = (0.0,0.0)
    @Published var endUserLocation: (lat: Double, lon: Double) = (0.0,0.0)
    var tokens: Set<AnyCancellable> = []
    @Published var shotDistance = 0.0
    @Published var shotDistance_yards = 0.0
    private var dlon = 0.0, dlat = 0.0, a = 0.0, c = 0.0
    init()
    {
        deviceLocationService.requestLocationUpdates()
        getCurrLocation()
    }
    
    func getCurrLocation()
    {
        deviceLocationService.coordinatesPublisher
        
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { coordinates in
                self.currLocation = (coordinates.latitude, coordinates.longitude)
            }
            .store(in: &tokens)
    }
    //func get user start location
    func userStartLocation()
    {
        startUserLocation.lat = currLocation.lat
        startUserLocation.lon = currLocation.lon

    }
    
    //func get user end location
    
    func userEndLocation()
    {
        endUserLocation.lat = currLocation.lat
        endUserLocation.lon = currLocation.lon
    }
    
    //func calculate distance between points
    
    func pointDistance()
    {
        dlon = deg2rad(endUserLocation.lon) - deg2rad(startUserLocation.lon)
        dlat = deg2rad(endUserLocation.lat) - deg2rad(startUserLocation.lat)
        a = pow(sin(dlat / 2),2) + cos(deg2rad(startUserLocation.lat)) * cos(deg2rad(endUserLocation.lat)) * pow(sin(dlon / 2),2)
        c = 2*asin(sqrt(a))
        shotDistance = c*EARTH_RAD_KM
        shotDistance_yards = distToYards(shotDistance)
    }
    
    //func convert degree to rad
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    //func convert distance to yards
    
    func distToYards(_ number: Double) -> Double
    {
        return number * 1093.61
    }
    
    //func store distance
    
    //func clear start and end location, distance travel
    func newShot()
    {
        startUserLocation = (0,0)
        endUserLocation = (0,0)
        //shotDistance = 0.0
    }
    
    func getHeading() -> Double
    {
       return deviceLocationService.heading
    }
    
    func headOrTail(windDirection: Double) -> Bool
    {
        //false = headWind true = tailwind
        var result = false
        let heading = getHeading()
        
        if (windDirection < heading+90 && windDirection < heading-90) {
            result = true
        }
        
        
        return result
    }
    
    func windEffect(headOrTail: Bool, windSpeed: Double) -> Double
    {
        var result = 0.0
        var convMPH = 0.0
        convMPH = windSpeed * 2.237
        if headOrTail == true{
            result = convMPH * 0.005
        }else{
            result = convMPH * 0.01
        }
        
        return result
    }
}
