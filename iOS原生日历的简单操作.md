# iOS系统日历的简单操作

-
### 概览
对系统日历的操作是通过官方的EventKit来实现的。下面是EventKit的结构



* iOS10之后，要访问系统日历，必须在plist中添加两个keys：NSRemindersUsageDescription以及NSCalendarsUsageDescription

	>Important

	>An iOS app linked on or after iOS 10.0 must include in its Info.plist file the usage description keys for the types of data it needs to access or it will crash. To access Reminders and Calendar data specifically, it must include NSRemindersUsageDescription and NSCalendarsUsageDescription, respectively.

	>To access the user’s Calendar data, all sandboxed macOS apps must include the com.apple.security.personal-information.calendars entitlement. To learn more about entitlements related to App Sandbox, see Enabling App Sandbox.


* 