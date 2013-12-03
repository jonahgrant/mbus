# Magic Bus

The University of Michigan has an awesome [live bus tracking system](http://mbus.pts.umich.edu/) for students.  This is an implementation of that for iOS 7 (and up).

This project runs on the [MVVM](http://en.wikipedia.org/wiki/Model_View_ViewModel) architecture, allowing abstraction of data-heavy code that would typically live in the view controller.  Because of this, we can test that data-heavy code where we couldn't easily before.

Additionally, this project runs using [ReactiveCocoa](https://github.com/blog/1107-reactivecocoa-for-a-better-world).  ReactiveCocoa allows us to, among other things, manage constantly updating values with an abstracted version of KVO.  For example, this is used in ```MapViewController``` to track updating values of an NSDictionary named ```annotations``` that represents a dictionary of ```MKAnnotations```, each of which corresponding with the current location of a University of Michigan bus.  When the dictionary's value is changed, the annotations are re-plotted.

NOTE: [their API](https://github.com/magic-bus/api-documentation/) is in pre-release, so some endpoints are incomplete, nonexistent, or supply faulty data.

## Approximating bus arrival time
The API for bus arrival times hasn't been released yet, so this project circumvents that by approximating it.  It's a crazy hack.  It does so by doing the following: 
* Receive a subclass of ```MKAnnotation``` containing a ```Stop``` object (which then contains a ```CLLocationCoordinate2D```) from user as a result of selecting a bus stop
* Fetch all routes currently running
* Run a loop through all routes returned and save the routes containing the id for the received Stop object
* Fetch all buses currently running
* Run a loop through all received buses and save the buses that are servicing one of the routes saved above
* Use ```-sortedArrayUsingComparator:``` to order all saved buses in order by distance relative to the ```Stop``` object
* Pull the first object (which represents the closest bus) in the sorted array
* Reverse geocode the ```Stop```'s ```CLLocationCoordinate2D``` to receive an ```MKPlacemark```
* Create an instance of ```MKDirectionsRequest``` with it's source being the ```Stop```'s ```CLLocationCoordinate2D``` and it's destination being the coordinate of the closest bus
* Run ```-calculateETAWithCompletionHandler:``` to receive an expected travel time in the form of an ```NSTimeInterval``` object
* Format the expected travel time object into a readable ```HH:mm:ss``` string

There is a lot of room for error in this approximation. It is calculating estimated time of arrival based on the assumption that the bus is going straight to the bus stop, on the most convenient route, without making any other stops.  Hence, it is an approximation.  A good way to improve approximation would be to find the stop that the bus is closest to, then calculate how long it will take for the bus to drive to each stop before arriving at the desired one. 
  Additionally, it does not auto-update off of a timer.  This would be very CPU heavy, take up a lot of memory, and eat bandwidth.

# Setup

If you don't already have [CocoaPods](http://cocoapods.org/), install it.

        gem install cocoapods
        pod setup
        
Clone this repository.

		git clone git@github.com:jonahgrant/um-magic-bus.git

Install it's dependencies
		
		cd um-magic-bus
		pod install

Open the workspace (not the project)
		
		open UMBus.xcworkspace
		
Run the project
		
		Select 'UMBus' target
		Run
		
		
# To do
The project currently only shows buses, bus stops, and announcements.  In the future, when the APIs are in place, it will show full routes and estimated time of arrival at each stop.

The project may also move to an alternate map provider that offers more flexibility in terms of scalability, performance (specifically when handling large amounts of polylines and annotations).

# Interface
![Live bus](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-03%20at%2012.30.09%20AM.png "Live bus")
![Bus stop](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-03%20at%2012.30.28%20AM.png "Bus stop")
![Street view](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-02%20at%206.31.20%20PM.png "Street view")
![Announcement](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-01%20at%2010.45.44%20PM.png "Announcement")

		
[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/0fe6bae62d6859d30f7f447fb3b2b188 "githalytics.com")](http://githalytics.com/jonahgrant/um-magic-bus)
