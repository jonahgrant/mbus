<img align="center" src="/Icons/header.png">

# MBus
The University of Michigan has an awesome [live bus tracking system](http://mbus.pts.umich.edu/) for students.  This is an iOS implementation of it.

This project runs on the [MVVM](http://en.wikipedia.org/wiki/Model_View_ViewModel) architecture, allowing abstraction of data-heavy code that would typically live in the view controller.

Additionally, this project runs using [ReactiveCocoa](https://github.com/blog/1107-reactivecocoa-for-a-better-world).  ReactiveCocoa allows us to, among other things, manage constantly updating values with an abstracted version of [KVO](https://developer.apple.com/library/Mac/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html).

MBus is available for free on the [App Store](https://itunes.apple.com/us/app/mbus-bus-info-for-university/id777435172?mt=8).
## Features

+  See nearby stops in service
+ See when the routes that are servicing a specific stop will arrive
+ Get a notification before your bus arrives
+ See a map of all buses moving in realtime
+ See all routes that are in service
+ See the stops that a route services and when the bus will arrive at each
+ See a map of a route with the buses that are servicing it
+ See all bus-related announcements
+ Easily call Safe Rides if no routes are in service

## Setup

If you don't already have [CocoaPods](http://cocoapods.org/), install it.

        gem install cocoapods
        pod setup

Clone this repository.

		git clone git@github.com:jonahgrant/mbus.git

Install it's dependencies

		cd mbus
		pod install

Open the workspace (not the project)

		open UMBus.xcworkspace

Run the project

		Select 'UMBus' target
		Run

## Interface
![Stop2](/Screenshots/Device/device-1.png "Stops")
![Stop](/Screenshots/Device/device-3.png "Stop")
![Route](/Screenshots/Device/device-4.png "Route")
![Map](/Screenshots/Device/device-5.png "Map")

## License
Copyright 2014 Jonah Grant

Available under the MIT License.
