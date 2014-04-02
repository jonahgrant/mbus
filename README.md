<img align="center" src="/Icons/header.png">

# MBus
The University of Michigan has an awesome [live bus tracking system](http://mbus.pts.umich.edu/) for students.  This is an iOS implementation of it.

This project operates on the [MVVM](http://en.wikipedia.org/wiki/Model_View_ViewModel) architecture, allowing abstraction of data-heavy code that would typically live in the view controller.

MBus runs using [ReactiveCocoa](https://github.com/blog/1107-reactivecocoa-for-a-better-world).  ReactiveCocoa allows us to, among other things, manage constantly updating values with an abstracted version of [KVO](https://developer.apple.com/library/Mac/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html).

Additionally, it is powered by [Fare](http://github.com/jonahgrant/fare), a networking library built around [AFNetworking](https://github.com/AFNetworking/AFNetworking) that interfaces with the University of Michigan's Parking and Transportation Service's API.

MBus is available for free on the [App Store](https://itunes.apple.com/us/app/mbus-bus-info-for-university/id777435172?mt=8).

## Features

+ See nearby stops in service sorted by distance
+ See what routes are servicing a specific stop at any given time
+ See the estimated time of arrival for different routes at a stop
+ Schedule a notification to notify you before your bus arrives
+ See a map of all buses moving in real-time
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

		open MBus.xcworkspace

Run the project

		Select 'MBus' target
    Select 'Debug' build scheme
		Run

## Interface
![Screenshots1](/Screenshots/MBUS-1.png "Screenshots1")
![Screenshots2](/Screenshots/MBUS-2.png "Screenshots2")

## License

MBus is available under the MIT License.

```
The MIT License (MIT)

Copyright (c) 2013-2014 Jonah Grant (http://jonahgrant.com).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
