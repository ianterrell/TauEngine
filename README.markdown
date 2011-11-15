# TauEngine!

This is a 2D game engine built from scratch for iOS 5's GLKit. It's powering at least one game live in the app store ([mine!](http://itunes.apple.com/us/app/galaxy-wild/id457266041)), but it's still early in its development. You may be more interested in the more mature [Cocos2d](http://www.cocos2d-iphone.org/) framework for game development. On the other hand, maybe you enjoy GLKit's helper functions and ARC—in which case, hack away!

## Features

* Scene management
* Object trees with smartly cached modelView matrices
* Shape drawing support (polygons, ellipses)
* Loader to create objects from JSON notation for quick editing
* Full 2d degrees of freedom: translation, rotation, scale
* Animation on all degrees of freedom
* Secondary and tertiary degrees of freedom: velocity, acceleration, angular velocity, angular acceleration
* Solid color and vertex color support
* Text, sprites, buttons
* Polygon and circle collision detection
* Utility functions for sound effects, random number generation, texture loading, etc

# Installation

You can set up your project to use TauEngine by using XCode's workspaces feature. Here is [a good blog post](http://blog.carbonfive.com/2011/04/04/using-open-source-static-libraries-in-xcode-4/) that details how to do it.