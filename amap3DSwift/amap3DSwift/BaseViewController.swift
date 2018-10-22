//
//  BaseViewController.swift
//  amap3DSwift
//
//  Created by BrodyGao on 17/4/3.
//  Copyright © 2017年 BrodyGao. All rights reserved.
//

import UIKit
class BaseViewController: UIViewController {
    override func viewDidLoad() {
        let backItem = UIBarButtonItem.init(title: "返回", style: .done, target: self, action: #selector(self.backAction))
        navigationItem.leftBarButtonItem = backItem
        self.view.backgroundColor = UIColor.white
    }
    
    @objc func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
}
