//
//  LocationService.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 11.03.2026.
//

import UIKit
import CoreLocation

protocol ILocationService {
    func fetchCurrentLocation(completion: @escaping (CLLocation) -> Void)
}

class LocationService: NSObject, ILocationService {
    
    //1
    private let locationManager = CLLocationManager()
    
    private var onLocationFetched: ((CLLocation) -> Void)?
    
    //2
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

//MARK: - Public
extension LocationService {
    
    //run -> 1
    func fetchCurrentLocation(completion: @escaping (CLLocation) -> Void) {
        locationManager.startUpdatingLocation()
        onLocationFetched = completion
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    //3
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            print("When user did not yet determined")
        case .restricted:
            print("Restricted by parental control")
        case .denied:
            print("When user select option Dont't Allow")
        case .authorizedAlways:
            print("When user select option Allow While Using App or Allow O")
        case .authorizedWhenInUse:
            print("When user select option Allow While Using App or Allow O")
        @unknown default:
            print("default")
        }
    }
    
    //run -> 2
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        
        locationManager.stopUpdatingLocation()
        onLocationFetched?(location)
    }
}
