//
//  UserNotificationHelper.swift
//  NotificationDemo
//
//  Created by 陈健 on 28/02/2017.
//  Copyright © 2017 陈健. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class UserNofificationHelper:NSObject {
    
    func checkAuthorization(denyBlock:@escaping () -> ()) {
        print("检查用户权限")
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings {
            settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.doAuthorization()
            case .denied:
                denyBlock()
            break // nothing to do, pointless to go on
            case .authorized:
                self.checkCategories()
                break
            }
        }
    }
    
    private func doAuthorization() {
        print("请求用户授权")
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { ok, err in
            if let err = err {
                print(err)
                return
            }
            if ok {
                self.checkCategories()
            } else {
                print("用户拒绝接收推送")
            }
        }
    }
    
    private func checkCategories() {
        print("checking categories")
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationCategories {
            cats in
            if cats.count == 0 {
                self.configureCategory()
            }
            self.createNotification()
        }
    }
    
    
    private func configureCategory() {
        print("配置category")
        

        let action1 = UNNotificationAction(identifier: "bite", title: "咬")
        let action2 = UNNotificationAction(identifier: "no",
                                           title: "不咬", options: [.foreground])
        let action3 = UNTextInputNotificationAction(identifier: "message", title: "沟通下再决定", options: [], textInputButtonTitle: "发送", textInputPlaceholder: "你好呀～")
        
        var customDismiss : Bool { return false }
        let dog = UNNotificationCategory(identifier: "notificationDemo", actions: [action1, action2], intentIdentifiers: [], options: customDismiss ? [.customDismissAction] : [])
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([dog])
        
        _ = action3
    }
    
    fileprivate func createNotification() {
        print("创建通知")
        
        //触发器
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        // 定义通知内容
        let content = UNMutableNotificationContent()
        content.title = "你好!"
        content.subtitle = "狗狗!"
        content.body = "你不能咬我"
        content.sound = UNNotificationSound.default()
        
//        //如果需要显示图片或者添加动作，必须定义categoryIdentifier
        content.categoryIdentifier = "notificationDemo"
//
        // ios10 之后可以添加图片
        let url = Bundle.main.url(forResource: "dog", withExtension: "jpg")!
        
        
        if let att = try? UNNotificationAttachment(identifier: "dog", url: url, options:nil) {
            content.attachments = [att]
            
        } else {
            print("添加附件失败")
        }
        
        
        let req = UNNotificationRequest(identifier: "dogNotification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(req)
    }
    
    func kickThingsOff() {
        // artificially, I'm going to start by clearing out any categories
        // otherwise, it's hard to test, because even after deleting the app...
        // the categories stick around and continue to be used
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([])
        
        // not so artificially, before we do anything else let's clear out all notifications
        // cool new iOS 10 feature, let's use it
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        
        // start the process
        self.checkAuthorization(denyBlock: {})
    }

}

extension UserNofificationHelper : UNUserNotificationCenterDelegate {
    
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("狗叫了")
        
        completionHandler([.sound, .alert])
        
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let id = response.actionIdentifier
        
        if id == "bite" {
            delay(1) {
                self.createNotification()
            }
        }
        
        
        if let textresponse = response as? UNTextInputNotificationResponse {
            let text = textresponse.userText
            print("输入了 \(text)")
        }
        
        
        completionHandler()
    }
    
}
