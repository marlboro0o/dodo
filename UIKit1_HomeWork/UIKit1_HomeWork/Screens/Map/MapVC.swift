//
//  MapVC.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 11.03.2026.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation

//1. Создаем mapView и растягиваем его на экран

//2. Берем локацию и регион и просовываем в карту

//3. Считываем локацию по центру карты с помощью метода делегата карты - mapView:regionDidChangeAnimated:

//4. Отображаем по центру карты иконку с пином

class MapVC: UIViewController {
    
    var bottomConstraint: NSLayoutConstraint?
    var originalConstant: CGFloat = 0
    var keyboardFrame: CGRect = .zero
    
    var locationService: ILocationService
    var geocodeService: IGeocodeService
    
    let addressPanelView = AddressPanelView()
    
    var pinImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "pin")
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        return imageView
    }()
    
    lazy var mapView: MKMapView = {
        var mapView = MKMapView()
        mapView.delegate = self
        
        return mapView
    }()
    
    init(locationService: ILocationService, geocodeService: IGeocodeService) {
        self.locationService = locationService
        self.geocodeService = geocodeService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupKeyboardNotifications()
        
        showCurrentLocationOnMap()
        
        observe()
    }
}

//MARK: - Observe Logic
extension MapVC {
    
    func observe() {
        
        addressPanelView.onAddressChanged = { [weak self] addressText in
            guard let self else { return }
            self.showAddressOnMap(addressText)
        }
    }
}


//MARK: - Business Logic
extension MapVC {
    
    func showCurrentLocationOnMap() {
        
        //run -> 1
        locationService.fetchCurrentLocation { [weak self] location in
            
            guard let self else { return }
            showLocationOnMap(location)
            
            fetchAddressFromLocation(location) { [weak self] addressText in
                self?.addressPanelView.update(addressText)
            }
        }
    }
    
    //run -> 2
    func showLocationOnMap(_ location: CLLocation) {
        let regionRadius: CLLocationDistance = 500.0
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    //run -> 3
    func fetchAddressFromLocation(_ location: CLLocation, completion: @escaping (String) -> Void) {
        self.geocodeService.fetchAddressFromLocation(location) { addressText in
            completion(addressText)
        }
    }
    
    func showAddressOnMap(_ addressText: String) {
        
        geocodeService.fetchLocationFromAddress(addressText) { [weak self] location in
            guard let self else { return }
            self.showLocationOnMap(location)
        }
    }
}

//MARK: - MKMapViewDelegate
extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapView.centerCoordinate
        print("did change ->", center)
        
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
       
        fetchAddressFromLocation(location) { addressText in
            self.addressPanelView.update(addressText)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        let center = mapView.centerCoordinate
        print("will change ->", center)
    }
}

//MARK: - Layout
extension MapVC {
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        view.addSubview(pinImageView)
        view.addSubview(addressPanelView)
    }
    func setupConstraints() {
        addressPanelView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
        }
        
        mapView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(addressPanelView.snp.top)
        }
        
        pinImageView.snp.makeConstraints { make in
            make.center.equalTo(mapView)
        }
    }
}

//MARK: - Keyboard
extension MapVC {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        addressPanelView.addressView.addressTextField.endEditing(true)
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UITextField.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UITextField.keyboardDidHideNotification, object: nil)
        
        self.bottomConstraint = addressPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        self.bottomConstraint?.isActive = true
    }
    
    @objc func keyboardWillShow(notification: Notification) {
           print("keyboardWillShow")
        
        self.keyboardFrame = (notification.userInfo?[UITextField.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        print(self.keyboardFrame)
        
        self.bottomConstraint?.constant = -self.keyboardFrame.height
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
       }

       @objc func keyboardWillHide(notification: Notification) {
           print("keyboardWillHide")
           self.keyboardFrame = .zero
           self.bottomConstraint?.constant = 0
           
           self.view.setNeedsLayout()
           self.view.layoutIfNeeded()
       }
}
