//
//  SingleLocaitonAloneViewController.swift
//  amap3DSwift
//
//  Created by BrodyGao on 17/4/5.
//  Copyright © 2017年 BrodyGao. All rights reserved.
//

import UIKit
class SingleLocaitonAloneViewController: BaseViewController ,AMapLocationManagerDelegate{
    var locationManager:AMapLocationManager!

    lazy var displayLabel:UILabel = {
        let textLabel = UILabel.init()
        textLabel.frame = UIScreen.main.bounds
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        initToolBar()
        configLocationManager()
        initDisplayLabel()
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
    
    func initDisplayLabel(){
        self.view.addSubview(displayLabel)
    }
    
    @objc func clearAction(){
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        self.displayLabel.text = nil
    }
    
    @objc func reGeocodeAction(){
        self.locationManager.requestLocation(withReGeocode: true, completionBlock: {location,regeocode,error -> Void in
            if (error != nil) {
                print(error!)
                return
            }

            if ((regeocode) != nil)
            {
                print("reGeocode:\(String(describing: regeocode))");

                self.displayLabel.text = String.init(format: "%@ \n %@-%@-%.2fm",regeocode!.formattedAddress, regeocode!.citycode,regeocode!.adcode,location!.horizontalAccuracy)
            }

        })
    }
    
    @objc func locAction(){
    
        self.locationManager.requestLocation(withReGeocode: false, completionBlock: { location, regeocode, error -> Void in
            if (error != nil) {
                print(error!)
                return
            }

            if ((regeocode) != nil)
            {
                print("reGeocode:\(String(describing: regeocode))");
                
                
            }else{
                print("location:\(String(describing: location))")
                self.displayLabel.text = String.init(format: "lat:%f;lon:%f \n accuracy:%.2fm", location!.coordinate.latitude,location!.coordinate.longitude,location!.horizontalAccuracy)
            }

        })
        
    }


}
