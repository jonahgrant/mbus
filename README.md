# Magic Bus

The University of Michigan has an awesome [live bus tracking system](http://mbus.pts.umich.edu/) for students.  This is an implementation of that for iOS 7 (and up).

This project runs on the [MVVM](http://en.wikipedia.org/wiki/Model_View_ViewModel) architecture, allowing abstraction of data-heavy code that would typically live in the view controller.  Because of this, we can test that data-heavy code where we couldn't easily before.

Additionally, this project runs using [ReactiveCocoa](https://github.com/blog/1107-reactivecocoa-for-a-better-world).  ReactiveCocoa allows us to, among other things, manage constantly updating values with an abstracted version of KVO.  For example, this is used in ```MapViewController``` to track updating values of an NSDictionary named ```annotations``` that represents a dictionary of ```MKAnnotations```, each of which corresponding with the current location of a University of Michigan bus.  When the dictionary's value is changed, the annotations are re-plotted.

NOTE: their API is in pre-release, so some endpoints are incomplete, nonexistent, or supply faulty data.

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
![Live bus](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-01%20at%2010.45.55%20PM.png "Live bus")
![Bus stop](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-01%20at%2010.45.47%20PM.png "Bus stop")
![Announcement](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-01%20at%2010.45.44%20PM.png "Announcement")

		

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/jonahgrant/um-magic-bus/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

