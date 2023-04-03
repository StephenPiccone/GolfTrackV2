//
//  DeviceLocationService.swift
//  GolfTrackV2
//
//  Created by Stephen Piccone on 2023-03-28.
//

import Combine
import CoreLocation

class DeviceLocationService: NSObject, CLLocationManagerDelegate, ObservableObject
{
    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Error>()
    var deniedLocationAccessPublisher = PassthroughSubject<Void, Never>()
    {
        willSet {
          objectWillChange.send()
        }
      }
    var heading: Double {
        willSet {
          objectWillChange.send()
        }
      }
    private override init() {
        heading = 0
        super.init()
    }
    
    static let shared = DeviceLocationService()
    
    private lazy var locationManager: CLLocationManager =
    {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.startUpdatingHeading()
        return manager
    }()
    
    func requestLocationUpdates() {
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            
            //Determine when location track should start
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            
            default:
            deniedLocationAccessPublisher.send()        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)
    {
        switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                manager.startUpdatingLocation()
                
            default:
            manager.stopUpdatingLocation()
            deniedLocationAccessPublisher.send()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last else {return}
        coordinatesPublisher.send(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinatesPublisher.send(completion: .failure(error))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.heading = Double(round(1 * newHeading.trueHeading) / 1)
        
    }
}

