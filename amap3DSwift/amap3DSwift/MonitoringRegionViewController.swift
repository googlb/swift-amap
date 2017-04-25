//
//  MonitoringRegionViewController.swift
//  amap3DSwift
//
//  Created by BrodyGao on 17/4/5.
//  Copyright © 2017年 BrodyGao. All rights reserved.
//

import Foundation
class MonitoringRegionViewController: BaseViewController,MAMapViewDelegate ,AMapLocationManagerDelegate {
    var locationManager:AMapLocationManager!
    var mapView:MAMapView!
    var regions:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocationManager()
        initMapView()
        self.regions = NSMutableArray.init()
        self.mapView.showsUserLocation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.toolbar.isTranslucent = true
        self.navigationController?.isToolbarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getCurrentLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
/**
         enumerateObjectsUsingBlock: 非常方便，但是其实从性能上来说这个方法并不理想 (这里有一篇四年前的星期五问答阐述了这个问题，而且一直以来情况都没什么变化)。另外这个方法要求作用在 NSArray 上，这显然已经不符合 Swift 的编码方式了。在 Swift 中，我们在遇到这样的需求的时候，有一个效率，安全性和可读性都很好的替代，那就是快速枚举某个数组的 */
        
//        self.regions.enumerateObjects({ (obj, idx,stop) in
//            self.locationManager.stopMonitoring(for: obj as! AMapLocationRegion)
//        })
        
        for (_,obj) in self.regions.enumerated(){
            self.locationManager.stopMonitoring(for: obj as! AMapLocationRegion)
        }
        
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
    
    //MARK: - Add regions
    func getCurrentLocation(){
        self.locationManager.requestLocation(withReGeocode: false, completionBlock: {location,regeocode,error -> Void in
            self.addCircleReionForCoordinate(coordinate: location!.coordinate)
        })
    }
    
    func addCircleReionForCoordinate(coordinate:CLLocationCoordinate2D){
        let cirRegin200:AMapLocationCircleRegion = AMapLocationCircleRegion.init(center: coordinate, radius: 200.0, identifier: "circleRegion200")
        
        let cirRegin300:AMapLocationCircleRegion = AMapLocationCircleRegion.init(center: coordinate, radius: 200.0, identifier: "circleRegion300")
        
        //添加地图围栏
        self.locationManager.startMonitoring(for: cirRegin200)
        self.locationManager.startMonitoring(for: cirRegin300)
        
        //保存地图围栏
        self.regions.add(cirRegin200)
        self.regions.add(cirRegin300)
        
        //添加Overlay
        let circle200:MACircle = MACircle.init(center: coordinate, radius: 200.0)
        let circle300:MACircle = MACircle.init(center: coordinate, radius: 300.0)
        self.mapView.add(circle200)
        self.mapView.add(circle300)
        
        self.mapView.setVisibleMapRect(circle300.boundingMapRect, animated: true)
        
        
    }
    
    

    
    //MARK:- AMapLocationManager Delegate
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        print(" amapLoctionManager error\(error)")
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didStartMonitoringFor region: AMapLocationRegion!) {
        print("didStartMonitoringForRegion:%@", region)
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, monitoringDidFailFor region: AMapLocationRegion!, withError error: Error!) {
        print("monitoringDidFailForRegion:%@", error.localizedDescription)
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didEnter region: AMapLocationRegion!) {
        print("didEnterRegion:%@", region)
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didExitRegion region: AMapLocationRegion!) {
        print("didExitRegion:%@", region)
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didDetermineState state: AMapLocationRegionState, for region: AMapLocationRegion!) {
        print("didDetermineState:%@; state:%ld", region, state)
    }
    
    //MARK: - MAMapViewDelegate
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolygon.self) {
            let polylineRenderer:MAPolygonRenderer = MAPolygonRenderer.init(overlay: overlay)
            polylineRenderer.lineWidth = 2.0
            polylineRenderer.strokeColor = UIColor.red
            return polylineRenderer
        }else if overlay.isKind(of: MACircle.self) {
            let circleRenderer:MACircleRenderer = MACircleRenderer.init(overlay: overlay)
            circleRenderer.lineWidth = 2.0
            circleRenderer.strokeColor = UIColor(red:0.09, green:0.90, blue:0.80, alpha:0.80)
            circleRenderer.fillColor = UIColor(red:0.28, green:0.71, blue:0.89, alpha:0.50)
            return circleRenderer
        }
        return nil
    }

}
