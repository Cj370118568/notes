# iOS事件传递链（一）
-
###简介

手指点击在屏幕上，就会产生一个touch的实例。UIResponder是touches的潜在接受者，UIView继承于UIResponder，一般而言UIView是唯一的接受者（还有其他的UIResponder子类但是其他的子类都是不可见的，UIView可见是由于它的Layer）。在实际中，系统会把UITouch对象包装成UIEvent传递到app中，然后app中找到合适的UIView来响应。

###触摸事件和view的关系
+ UIEvent就是对用户触摸操作的封装，一个UIEvent包含一个或多个UITouch对象。每个UITouch对象跟一个手指相关。一旦UITouch创建，它代表着相关的手指离开屏幕前所作的操作
+ UITouch的4种状态：
	+ .began
	+ .moved
	+ .stationary
	+ .ended

	这四种状态足以描述出手指能做的所有操作，其实还有另外一种状态
	
	+ cancelled

	系统会向app发出这几种状态（封装成UIEvent）
+  	当UITouch第一次出现（.began），你的app会找到响应的UIView，然后这个view就会成为UITouch对象的view属性，从此以后，UITouch就会在手指离开屏幕之前一直与这个view绑定。
+   组成UIEvent的UITouches有可能与不同的view绑定，因此，UIEvent会传递到与组成这个UIEvent的UITouches相关的所有view。
+   反过来说，若是一个UIEvent传递到某个view上，是因为UIEvent中的至少一个UITouch的view是当前view
+   如果UIEvent里面的每一个UITouch绑定同一个UIView，并且状态是.stationary的话，这个UIEvent是不会传递到UIView的，因为没有任何的事情会发生。


###接收触摸事件
+ 一个UIResponder，或者说是一个UIView,有四个跟UITouch对应的方法。通过调用这四个方法之中的一个来把UIEvent传递到UIView。

	+ touchesBegan(_:with:)
	+ touchesMoved(_:with:)
	+ touchesEnded(_:with:)
	+ touchesCacelled(_:with:)

	这四个方法的参数是：
	
	+ The relevant touches

		UIEvent里面包含的一个或多个UITouch，以Set的形式传递过来。
	
	+ The event
	
		UIEvent的对象。包含一个touches的集合，你可以通过allTouches来获取。这个集合包含第一个参数里面的集合，但不局限于此。

+ UITouch有一些常用的方法和属性

	+ location(in:),previousLocation(in:)
	+ timestamp
	+ tapCount
	+ view
	+ majorRadius,majorRadiusTolerance

###限制触摸事件的传递
+ 通过系统级别的beginIgnoringInteractionEvents属性，可以完全忽略所有的触摸事件。

+ 与之对应的是endIgnoringInteractionEvents。这对属性在动画或者其他长时间的操作中经常用到。

+ 一些UIView的属性也能限制特定views的触摸事件的传递。

	+ isUserInteractionEnabled
	+ alpha
	+ isHidden
	+ isMultipleTouchEnabled
	+ isExclusiveTouch

###事件传递
+ 当一个touch出现，系统会通过hit-testing来找到对此响应的view。然后这个view会与这个touch绑定，因此叫做hit-test view。UIView的一些属性如：isUserInteractionEnable，isHidden，alpha就是通过影响系统的hit-test过程来实现让系统忽略这个view的目的。
+ 每次触摸状态改变的时候，
	+ 系统都会调用自己的sentEvent(_:)方法，
	+ 传递到window，window再调用它的sentEvent(_:)方法
	+ 触摸事件第一次出现的时候，系统会考虑```isMultipleTouchEnabled```以及```isExclusiceTouch```
	+ 不违反相应规则的情况下，以下两种情况都有可能发生：
		+ 触摸事件传递到hit-test view的gesture recognizers
		+ 触摸事件传递到hit-test view本身
	+ 当触摸事件被一个gesture recognizer识别，对于所有与这个手势相关的触摸：
		+ touchsCancelled(_:for:)会传递到touch绑定的view，之后touch不再会传递给这个view
		+ 如果touch还与其他的gesture recognizer相关，那些gesture recognizer会识别失败

###Hit-Testing
Hit-testing就是系统用来决定哪一个view来响应触摸事件的过程，是通过UIView的实例方法hitTest(_:with:)来实现的，这个方法放回一个view或者nil。目的就是找出在最上层的，包含触摸点的view。逻辑如下：

1. view的hitTest(_:with:)方法首先会在view的子view上调用hitTest方法。如果是两个相同层级的view，在上面的那个view会先调用hitTest方法。
1. 一旦这些subviews的其中一个的hitTest返回view而不是nil，这个寻找过程就会停止，那一个view就会成为hit-test view。
2. 如果这个view没有subview，或者说他的所有subview都返回nil，那么这个view会自己调用point(inside:with:)这个方法，如果触摸点是在这个view里面，这个view会返回自己，这代表着自己就是hit-test view,否则会返回nil

如果一个view的isUserInteractionEnabled被设成false,或者说isHidden被设成true，或者alpha被设成0，hitTest方法直接返回nil，子view不会调用hitTest方法，自身也不会调用point(inside:with:)方法。

+ 重写hitTest方法

	你可以在子类中重写hitTest(_:with:)方法来影响系统的hit-test过程，从而实现某种目的。
	
	其中一种用途：当父view的clipsToBounds被设成false的时候，子view超出父view的范围你还是能看到，但是这种情况下子view超出父view的范围是不能正常接收点击事件的。这个时候重写hit-test方法就能解决这个问题。
	
	```Swift
	override func hitTest(_ point: CGPoint, with e: UIEvent?) -> UIView? {
    if let result = super.hitTest(point, with:e) {
        return result
    }
    for sub in self.subviews.reversed() {
        let pt = self.convert(point, to:sub)
        if let result = sub.hitTest(pt, with:e) {
            return result
        }
    }
    return nil
}
```

###小结
本文概述性地介绍了iOS中的事件传递机制，说明了UIView是触摸事件的接收者，说明了系统是怎样找到app中处理触摸事件的view，介绍了hit-test的过程。

下一篇事件传递的文章会继续研究iOS中的事件传递，内容包括UIGestureRecognize，以及整个触摸响应过程的更详细介绍。