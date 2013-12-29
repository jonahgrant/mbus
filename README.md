# Magic Bus
[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/0fe6bae62d6859d30f7f447fb3b2b188 "githalytics.com")](http://githalytics.com/jonahgrant/um-magic-bus)
The University of Michigan has an awesome [live bus tracking system](http://mbus.pts.umich.edu/) for students.  This is an implementation of that for iOS 7 (and up).

This project runs on the [MVVM](http://en.wikipedia.org/wiki/Model_View_ViewModel) architecture, allowing abstraction of data-heavy code that would typically live in the view controller.  Because of this, we can test that data-heavy code where we couldn't easily before.

Additionally, this project runs using [ReactiveCocoa](https://github.com/blog/1107-reactivecocoa-for-a-better-world).  ReactiveCocoa allows us to, among other things, manage constantly updating values with an abstracted version of [KVO](https://developer.apple.com/library/Mac/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html).  For example, this is used in ```MapViewController``` to track updating values of an NSDictionary named ```annotations``` that represents a dictionary of ```MKAnnotations```, each of which corresponding with the current location of a University of Michigan bus.  When the dictionary's value is changed, the annotations are re-plotted.

### Features

+  See nearby stops in service 
+ See when the routes that are servicing a specific stop will arrive 
+ Get a notification before your bus arrives 
+ See a map of all buses moving in realtime 
+ See all routes that are in service 
+ See the stops that a route services and when the bus will arrive at each 
+ See a map of a route with the buses that are servicing it 
+ See all bus-related announcements 
+ Easily call Safe Rides if no routes are in service

# Setup

If you don't already have [CocoaPods](http://cocoapods.org/), install it.

        gem install cocoapods
        pod setup
        
Clone this repository.

		git clone git@github.com:jonahgrant/um-magic-bus.git

Install it's dependencies
		
		cd um-bus
		pod install

Open the workspace (not the project)
		
		open UMBus.xcworkspace
		
Run the project
		
		Select 'UMBus' target
		Run
		
# Interface
![Stop](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-23%20at%2011.42.24%20AM.png "Stop")
![Routes](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-23%20at%2011.42.29%20AM.png "Routes")
![Route](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-23%20at%2011.50.19%20AM.png "Route")
![Route map](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-23%20at%2011.50.27%20AM.png "Route map")
![Live bus](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-23%20at%2011.50.38%20AM.png "Live bus")
![Announcmenets](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-23%20at%2011.50.40%20AM.png "Announcements")