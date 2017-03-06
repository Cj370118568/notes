//
//  ViewController.swift
//  CalendarDemo
//
//  Created by 陈健 on 2017/2/16.
//  Copyright © 2017年 陈健. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {

    
    let eventStore = EKEventStore()
    
    let date = Date()
    
    var calenders = [EKCalendar]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.askForPermit()
        
        self.calenders = self.eventStore.calendars(for: EKEntityType.reminder) as [EKCalendar]//EKEntityType.Reminder
        
       
        
        let endDate = date.addingTimeInterval(24 * 60 * 60)
        let predicate = self.eventStore.predicateForEvents(withStart: self.date, end: endDate, calendars: self.calenders)
        let array = self.eventStore.events(matching: predicate)  //得到事件数组
        
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func askForPermit() {
        // 1
        
        
        // 2
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        @IBAction func notify(_ sender: UIButton) {
        }
        
        switch status {
        case .authorized:
            insertEvent(store: eventStore)
        case .denied:
            print("Access denied")
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: EKEntityType.event, completion: { (granted, error) in
                if granted {
                    self.insertEvent(store: self.eventStore)
                } else {
                    print("Access denied")
                }
            })
            
        default:
            print("Case Default")
        }
    }
    
    
    func insertEvent(store: EKEventStore) {
        // 1
        let calendars = store.calendars(for: EKEntityType.event)
            as [EKCalendar]
        
        
        
        for calendar in calendars {
            // 2
            if calendar.title == "Calendar" {
                // 3
                let startDate = NSDate()
                // 2 hours
                let endDate = startDate.addingTimeInterval(2 * 60 * 60)
                
                // 4
                // Create Event
                let event = EKEvent(eventStore: store)
                event.calendar = calendar
                
                event.title = "New Meeting"
                event.startDate = startDate as Date
                event.endDate = endDate as Date
                
                // 5
                // Save Event in Calendar
                
                do {
                    
                    try store.save(event, span: EKSpan.thisEvent)
                    
                }
                catch {
                    print("An error occured")
                }
                
                
            }
        }
    }
    
}

