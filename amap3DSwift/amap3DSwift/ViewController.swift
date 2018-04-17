//
//  ViewController.swift
//  amap3D-swift
//
//  Created by BrodyGao on 17/3/30.
//  Copyright © 2017年 BrodyGao. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var tableView:UITableView!
    lazy var sections:[String] = {
        return []
    }()
    lazy var items:[NSArray] = {
        return [NSArray]()
    }()
    var classNames:[NSArray] = {
        return [NSArray]()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AMAPLocationKit-Demo"
        initTitle()
        initClassNames()
        initTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureAPIKey()
    }
    
    func initTitle(){
        self.sections = ["基本功能"]
        let sec1CellTitle:NSArray = ["单次定位地图","单次定位不带地图展示","连续定位","地理围栏"]
        self.items = [sec1CellTitle]
        
    }
    
    func initTableView(){
        self.tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(tableView)
    }
    
    func initClassNames(){
        let sec1ClassNames:NSArray = ["SingleLocationViewController",
                                      "SingleLocaitonAloneViewController",
                                      "SerialLocationViewController",
                                      "MonitoringRegionViewController"]
        self.classNames = [sec1ClassNames]
    }
    
    func configureAPIKey(){
        if APIKey.APIkey.length == 0 {
            let alertController = UIAlertController(title: "提示", message: "请设置APIKey", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                //
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        AMapServices.shared().apiKey = APIKey.APIkey as String?
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        //
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cellIdentifier = "cellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        cell!.textLabel?.text = self.items[indexPath.section][indexPath.row] as? String
        cell!.detailTextLabel?.text = self.classNames[indexPath.section][indexPath.row] as? String
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let className = self.classNames[indexPath.section][indexPath.row] as! String
        
        
        guard let nameSpace = (Bundle.main.infoDictionary!["CFBundleExecutable"] as? String)  else {
            print( "没有获取命名空间")
            return
        }
        
      //1.根据字符创获取对应的Class
        guard let childVcClass = NSClassFromString(nameSpace + "." + className)  else {
            print("没有获取到字符创对应的Class")
            return
        }
        
        guard let childVcType = childVcClass as? BaseViewController.Type else {
            print("没有获取对应控制器的类型")
            return
        }
        
        let childVc = childVcType.init()
        childVc.title = self.items[indexPath.section][indexPath.row] as? String
        self.navigationController?.pushViewController(childVc, animated: true)
    }
    
    
    
}

