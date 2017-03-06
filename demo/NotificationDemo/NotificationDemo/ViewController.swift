//
//  ViewController.swift
//  NotificationDemo
//
//  Created by 陈健 on 28/02/2017.
//  Copyright © 2017 陈健. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    let notificationHelper = UserNofificationHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    private func gotoSetting() {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: ["":""], completionHandler: nil)
            }
        }
        
    }
    
    
    @IBAction func notify(_ sender: UIButton) {
        self.notificationHelper.checkAuthorization {
            let alert = UIAlertController(title: "你要允许app接收推送信息吗", message: nil, preferredStyle: .alert)
            //        unowned let weakSelf = self
            let action = UIAlertAction(title: "去设置", style: .default) { (action) in
                self.gotoSetting()
            }
            let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(action1)
            self.show(alert, sender: nil)
        }
    }
    
}

