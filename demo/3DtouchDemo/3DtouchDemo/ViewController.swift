//
//  ViewController.swift
//  3DtouchDemo
//
//  Created by 陈健 on 20/03/2017.
//  Copyright © 2017 陈健. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let item = UIApplicationShortcutItem(type: "demo.dynamic",
        localizedTitle: "dynamic", localizedSubtitle: "你不是🐶",
        icon: UIApplicationShortcutIcon(templateImageName: "dog"),
        userInfo: ["name":"dog"])
        UIApplication.shared.shortcutItems = [item]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

