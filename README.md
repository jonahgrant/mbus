# Magic Bus
[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/0fe6bae62d6859d30f7f447fb3b2b188 "githalytics.com")](http://githalytics.com/jonahgrant/um-magic-bus)
The University of Michigan has an awesome [live bus tracking system](http://mbus.pts.umich.edu/) for students.  This is an implementation of that for iOS 7 (and up).

This project runs on the [MVVM](http://en.wikipedia.org/wiki/Model_View_ViewModel) architecture, allowing abstraction of data-heavy code that would typically live in the view controller.  Because of this, we can test that data-heavy code where we couldn't easily before.

Additionally, this project runs using [ReactiveCocoa](https://github.com/blog/1107-reactivecocoa-for-a-better-world).  ReactiveCocoa allows us to, among other things, manage constantly updating values with an abstracted version of [KVO](https://developer.apple.com/library/Mac/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html).  For example, this is used in ```MapViewController``` to track updating values of an NSDictionary named ```annotations``` that represents a dictionary of ```MKAnnotations```, each of which corresponding with the current location of a University of Michigan bus.  When the dictionary's value is changed, the annotations are re-plotted.

## Purpose

On a campus visit during classes I sat in on and tours I went on, the '[Magic Bus](http://mbus.pts.umich.edu/)' was something that was brought up repeatedly.  When I got home, I did a little bit of research on it seeing that it had easily-accessible XML feeds and an API.  

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