//
//  NotificationViewController.swift
//  NotificationUI
//
//  Created by 陈健 on 06/03/2017.
//  Copyright © 2017 陈健. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        self.preferredContentSize = CGSize(width: 320, height: 250)
    }
    
    func didReceive(_ notification: UNNotification) {
        
        
        let req = notification.request
        let content = req.content
        let atts = content.attachments
        if let att = atts.first, att.identifier == "dog" {
            if att.url.startAccessingSecurityScopedResource() { //
                if let data = try? Data(contentsOf: att.url) {
                    self.imageView.image = UIImage(data: data)
                }
                att.url.stopAccessingSecurityScopedResource()
            }
        }
        self.view.setNeedsLayout()
    }

}
