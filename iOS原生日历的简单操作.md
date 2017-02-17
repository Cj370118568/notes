# iOS系统日历的简单操作

-
### 概览

对日历的操作是通过官方的EventKit来实现的。

下面是EventKit的结构
![EventKit结构](https://github.com/Cj370118568/notes/blob/master/1.png?raw=true)

通过EventKit,我们可以：


操作日历事件（新增，修改，删除日程）




###查询事件

1. iOS10之后，要访问系统日历以及提醒事项，必须在plist中添加两个keys：NSRemindersUsageDescription以及NSCalendarsUsageDescription

	>Important

	>An iOS app linked on or after iOS 10.0 must include in its Info.plist file the usage description keys for the types of data it needs to access or it will crash. To access Reminders and Calendar data specifically, it must include NSRemindersUsageDescription and NSCalendarsUsageDescription, respectively.

	>To access the user’s Calendar data, all sandboxed macOS apps must include the com.apple.security.personal-information.calendars entitlement. To learn more about entitlements related to App Sandbox, see Enabling App Sandbox.


1. 获得用户的允许

		// 1
        let eventStore = EKEventStore()
        
        // 2
        
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch status {
        case .authorized:
            insertEvent(store: eventStore)
        case .denied:
            print("Access denied")
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: EKEntityType.event, completion: { (granted, error) in
                if granted {
                    
                } else {
                    print("Access denied")
                }
            })
            
        default:
            print("Case Default")
        }
   1. 创建一个事件库实例
   2. EKEntityType有两种:reminder以及event
   3. 若是用户还没确定，请求访问权限
1. 获取日历数组
		
		self.calenders = self.eventStore.calendars(for: 		EKEntityType.event) as [EKCalendar]//		EKEntityType.Reminder
2. 确定查询条件，获取事件数组

		let endDate = date.addingTimeInterval(24 * 60 * 60)
        let predicate = self.eventStore.predicateForEvents(withStart: self.date, end: endDate, calendars: self.calenders)
        let array = self.eventStore.events(matching: predicate)  //得到事件数组
        
###新增事件
 在日历中新增事件比较简单，找到你想要添加的日历，然后创建一个EKEvent对象，设置完相关属性后保存就行了

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
    
###修改日历事件
修改日历事件也很简单，只需修改获取到的事件属性，然后保存到对应的事件库就好。这里需要注意一点，事件是从哪个事件库中拿出来的，保存的时候也要保存到对应的事件库（EKEventStore），否则会报错。
     
      do {
           try store.save(event, span: EKSpan.thisEvent)         
      }
      catch {
              print("An error occured")
      }
###总结
本文对iOS日历开放出来的接口进行了简单的概述，更多细节的操作会在后面进行更新。
###参考
+ [Introduction to Calendars and Reminders] (https://developer.apple.com/library/content/documentation/DataManagement/Conceptual/EventKitProgGuide/Introduction/Introduction.html)
+ [Cookbook: 制作一个日历提醒事项] (http://www.tairan.com/archives/7729/)
+ [iOS8使用EventKit添加日历事件-Swift教程] (https://www.swiftmi.com/topic/248.html)

