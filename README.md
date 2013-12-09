# Magic Bus

The University of Michigan has an awesome [live bus tracking system](http://mbus.pts.umich.edu/) for students.  This is an implementation of that for iOS 7 (and up).

This project runs on the [MVVM](http://en.wikipedia.org/wiki/Model_View_ViewModel) architecture, allowing abstraction of data-heavy code that would typically live in the view controller.  Because of this, we can test that data-heavy code where we couldn't easily before.

Additionally, this project runs using [ReactiveCocoa](https://github.com/blog/1107-reactivecocoa-for-a-better-world).  ReactiveCocoa allows us to, among other things, manage constantly updating values with an abstracted version of KVO.  For example, this is used in ```MapViewController``` to track updating values of an NSDictionary named ```annotations``` that represents a dictionary of ```MKAnnotations```, each of which corresponding with the current location of a University of Michigan bus.  When the dictionary's value is changed, the annotations are re-plotted.

NOTE: [their API](https://github.com/magic-bus/api-documentation/) is in pre-release, so some endpoints are incomplete, nonexistent, or supply faulty data.

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
![Arrivals](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-09%20at%2012.13.39%20AM.png "Arrivals")
![Route](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-09%20at%2012.20.18%20AM.png   "Route")
![Route map](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-09%20at%2012.13.59%20AM.png "Route map")
![Street view](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-09%20at%2012.14.16%20AM.png "Street view")
![Live bus](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-09%20at%2012.14.35%20AM.png "Live bus")
![Announcement](https://dl.dropboxusercontent.com/u/2177718/Screen%20Shot%202013-12-09%20at%2012.14.38%20AM.png "Announcement")

		
[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/0fe6bae62d6859d30f7f447fb3b2b188 "githalytics.com")](http://githalytics.com/jonahgrant/um-magic-bus)
