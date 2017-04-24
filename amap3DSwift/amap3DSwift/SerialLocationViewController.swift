//
//  SerialLocationViewController.swift
//  amap3DSwift
//
//  Created by BrodyGao on 17/4/5.
//  Copyright © 2017年 BrodyGao. All rights reserved.
//

import Foundation
class SerialLocationViewController: BaseViewController,MAMapViewDelegate ,AMapLocationManagerDelegate{
    var locationManager:AMapLocationManager!
    var mapView:MAMapView!
    var pointAnnotaion:MAPointAnnotation!
    var showSegment:UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocationManager()
        initMapView()
        initToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.toolbar.isTranslucent = true
        self.navigationController?.isToolbarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.locationManager.startUpdatingLocation()
    }
    
    
    //MARK: - init
    func configLocationManager(){
        self.locationManager = AMapLocationManager.init()
        self.locationManager.delegate = self
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.allowsBackgroundLocationUpdates = true

    }
    
    func initMapView(){
        self.mapView = MAMapView.init(frame: self.view.bounds)
        self.mapView.delegate = self
        self.view.addSubview(mapView)
    }
    
    func initToolbar(){
        let flexble:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.showSegment = UISegmentedControl.init(items: ["Start","Stop"])
        self.showSegment.addTarget(self, action: #selector(showSegmentAction(sender:)), for: .valueChanged)
        self.showSegment.selectedSegmentIndex = 0
        let showItem = UIBarButtonItem.init(customView: self.showSegment)
        self.setToolbarItems([flexble,showItem,flexble], animated: true)
    }
    
    func showSegmentAction(sender:UISegmentedControl){
        if sender.selectedSegmentIndex == 1 {
            self.locationManager.stopUpdatingLocation()
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.pointAnnotaion = nil
        }else{
            self.locationManager.startUpdatingLocation()
        }
    }
    
    //MARK:- AMapLocationManager Delegate
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        print(" amapLoctionManager error\(error)")
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        print("location:{lat:\(location.coordinate.latitude);lon:\(location.coordinate.longitude);accuracy:\(location.horizontalAccuracy)}")
        if self.pointAnnotaion == nil {
            self.pointAnnotaion = MAPointAnnotation.init()
            self.pointAnnotaion.coordinate = location.coordinate
            self.mapView.addAnnotation(self.pointAnnotaion)
        }
        
        self.pointAnnotaion.coordinate = location.coordinate
        self.mapView.centerCoordinate = location.coordinate
        self.mapView.zoomLevel = 15.1
        
    }
    
    //MARK:-MapView Delegate
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAAnnotation.self) {
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
