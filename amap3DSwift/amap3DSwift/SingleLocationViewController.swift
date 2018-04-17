//
//  SingleLocationViewController.swift
//  amap3DSwift
//
//  Created by BrodyGao on 17/4/3.
//  Copyright © 2017年 BrodyGao. All rights reserved.
//

import UIKit
class SingleLocationViewController: BaseViewController,MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate{
    var mapView:MAMapView!
    var search:AMapSearchAPI!
    var locationManager:AMapLocationManager!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMapView()
        initToolBar()
        initNavigationBar()
        configLocationManager()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.clearAction()
    }
    
    
    
    func initMapView(){
        self.mapView = MAMapView.init(frame: self.view.frame)
        self.mapView.delegate = self
        self.view.addSubview(mapView)
    }
    
    func configLocationManager(){
        self.locationManager = AMapLocationManager.init()
        self.locationManager.delegate = self
        
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        //高精度：kCLLocationAccuracyBest，可以获取精度很高的一次定位，偏差在十米左右
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.allowsBackgroundLocationUpdates = true
        //   定位超时时间，最低2s
        self.locationManager.locationTimeout = 6
        //   逆地理请求超时时间，最低2s
        self.locationManager.reGeocodeTimeout = 3
    }
    
    func initNavigationBar(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "清除", style: .done, target: self, action: #selector(self.clearAction))
    }
    
    func initToolBar(){
        let flexble = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let reGeocodeItem = UIBarButtonItem.init(title: "带逆地理定位", style: .done, target: self, action: #selector(self.reGeocodeAction))
        let locItem = UIBarButtonItem.init(title: "不带逆地理定位", style:.done, target: self, action: #selector(self.locAction))
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.setToolbarItems([flexble,reGeocodeItem,flexble,locItem], animated: true)
    }
    
    func clearAction(){
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    
    func reGeocodeAction(){
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.locationManager.requestLocation(withReGeocode: true, completionBlock: {location,regeocode,error -> Void in
            if (error != nil) {
                print(error!)
                return
            }
            let annotation:MAPointAnnotation = MAPointAnnotation.init()
            annotation.coordinate = location!.coordinate
            if ((regeocode) != nil)
            {
                print("reGeocode:\(String(describing: regeocode))");
                annotation.title = regeocode?.formattedAddress
                annotation.subtitle = String.init(format: "%@-%@-%.2fm", regeocode!.citycode,regeocode!.adcode,location!.horizontalAccuracy)
            }
            self.addAnnotationToMapView(annotation: annotation)
        })
    }
    
    func locAction(){
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.locationManager.requestLocation(withReGeocode: false, completionBlock: { location, regeocode, error -> Void in
            if (error != nil) {
                print(error!)
                return
            }
            let annotation:MAPointAnnotation = MAPointAnnotation.init()
            annotation.coordinate = location!.coordinate
            if ((regeocode) != nil)
            {
                print("reGeocode:\(String(describing: regeocode))");
                
                
            }else{
                annotation.title = String.init(format: "lat:%f;lon:%f", location!.coordinate.latitude,location!.coordinate.longitude)
                print("location:\(String(describing: location))")
                annotation.subtitle = String.init(format: "accuracy:%.2fm", location!.horizontalAccuracy)
            }
            self.addAnnotationToMapView(annotation: annotation)
        })

    }
    
    func addAnnotationToMapView(annotation:MAAnnotation){
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
        self.mapView.setZoomLevel(15.1, animated: false)
        self.mapView.setCenter(annotation.coordinate, animated: true)
    
    }
    
    
    
    //MARK: - mapView delegate
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let  pointReuseIndentifier = "pointReuseIndentifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndentifier)  as! MAPinAnnotationView?
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndentifier)
                
            }
            annotationView!.canShowCallout = true
            annotationView!.isDraggable = false
            //annotationView!.isSelected = true
            annotationView!.animatesDrop = true
            annotationView!.pinColor = MAPinAnnotationColor.purple
            return annotationView
        }
        return nil
    }
    
    
}

