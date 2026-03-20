//
//  GeocodeService.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 11.03.2026.
//

import Foundation
import CoreLocation

protocol IGeocodeService {
    func fetchLocationFromAddress(_ addressText: String, completion: @escaping (CLLocation) -> Void)
    func fetchAddressFromLocation(_ location: CLLocation, completion: @escaping (String) -> Void) 
}

class GeocodeService: IGeocodeService {
    
    var geoCoder = CLGeocoder()
    
    func fetchLocationFromAddress(_ addressText: String, completion: @escaping (CLLocation) -> Void) {
        
       // let addressString = "Ростов-на-Дону, Ерёменко 110, строение 2"
        let addressString = addressText
        geoCoder.geocodeAddressString(addressString) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemarks found")
                return
            }
            let location = placemark.location
            print("Latitude: \(location?.coordinate.latitude ?? 0), Longtitude: \(location?.coordinate.longitude ?? 0)")
            if let location = location {
                completion(location)
            }
            
        }
    }
    
    func fetchAddressFromLocation(_ location: CLLocation, completion: @escaping (String) -> Void) {
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ru_RU")) { placemarks, error in
            
            if let place = placemarks?.first {
                
                print(place.country)
                print(place.administrativeArea)
                print(place.locality)
                
                print(place.name) //Манеж
                print(place.subAdministrativeArea)
                print(place.subLocality) //Tverskoy District
                print(place.thoroughfare) //Манежная улица
                print(place.subThoroughfare) //номер дома
                
                
                var address: [String] = []
                
                if let locality = place.locality { //
                    address += [locality]
                }
                
//                if let subLocality = place.subLocality {
//                    address += [subLocality]
//                }
                
                if let thoroughfare = place.thoroughfare {
                    address += [thoroughfare]
                }
                
                if let subThoroughfare = place.subThoroughfare {
                    address += [subThoroughfare]
                }
                
                let result = address.joined(separator: ", ")
                
               completion(result)
                
                
                print("->", result)
            }
        }
        
      
    }
}
