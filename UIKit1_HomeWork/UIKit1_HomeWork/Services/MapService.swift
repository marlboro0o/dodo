//
//  MapService.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 11.03.2026.
//

import Foundation

protocol IMapService {
    var geocodeService: IGeocodeService { get }
    var locationService: ILocationService { get }
}

class MapService: IMapService {
    let geocodeService: IGeocodeService
    let locationService: ILocationService
    
    init(geocodeService: IGeocodeService, locationService: ILocationService) {
        self.geocodeService = geocodeService
        self.locationService = locationService
    }
}
