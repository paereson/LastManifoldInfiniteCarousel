# Last Manifold Infinite Carousel
![infiniteCaruoselGif](https://github.com/LastManifold/LastManifoldInfiniteCarousel/blob/master/Resources/infiniteCarousel.gif?raw=true)

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![License](https://img.shields.io/badge/licence-GPL--3.0-informational.svg) ![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg) ![Swift](https://img.shields.io/badge/swift-5.0-orange.svg)

## Description

**LastManifoldInfiniteCarousel** is @IBDesignable extension to UIView you can easily create an infinite carousel from your views. Works with at least three views.

## Installation

**LastManifoldInfiniteCarousel** is available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

    github "LastManifold/LastManifoldInfiniteCarousel"

## Usage

Create UIView in your .nib or .storyboard file, and add 
```swift
LMInfiniteCarousel
```
as class.

Connect outlet to View Controller
```swift
@IBOutlet  weak  var  infiniteCarousel: LMInfiniteCarousel!
```

In ViewDidAppear load your slides. 

```swift
override func viewDidAppear(_ animated: Bool) {
	super.viewDidAppear(animated)
	guard let view1 = Bundle.main.loadNibNamed("View1", owner: self, options: nil)?.first as? UIView,
	let view2 = Bundle.main.loadNibNamed("View2", owner: self, options: nil)?.first as? UIView,
	let view3 = Bundle.main.loadNibNamed("View3", owner: self, options: nil)?.first as? UIView else { return }

	infiniteCarousel.slides = [view1, view2, view3]
}
```

### Warning

If You have 
```ruby
<Your App>[Storyboard] Unknown class LMInfiniteCarousel in Interface Builder file.
```

error after run, add 
```ruby
LastManifoldInfiniteCarousel
```
as module.

![lastManifoldCustomClass](https://github.com/LastManifold/LastManifoldInfiniteCarousel/blob/master/Resources/infiniteCarousel.png?raw=true)

## Configuration

**LastManifoldInfiniteCarousel** gives user possibility to customize view.

You can set it in the interface builder, or you can set it programmatically. Slides are loaded proportionally to superview.

```swift
widthPercent //The width of the main slide proportional to superview(default: 70)
heightPercent //The height of the main slide proportional to superview(default: 70)
sideViewPercentSize //Proportional size of side slides to the main slide(default: 70)
slidesOffset //Distance between slides(default: 10)
```

Example:

```swift
infiniteCarousel.widthPercent = 80
```
Or in interface builder

![LastManifoldChangeView](https://github.com/LastManifold/LastManifoldInfiniteCarousel/blob/master/Resources/infiniteCarousel1.png?raw=true)

You can add UIPageControl and take its value from number of pages from getSlidesCount() func.
```swift
pageControl.numberOfPages = infiniteCarousel.getSlidesCount()
```

## LMInfiniteCarouselDelegate

To update UIPageControl, use the pageChanged() func from delegate. 
Add
```swift
infiniteCarousel.delegate = self
```
and
```swift
extension  ViewController: LMInfiniteCarouselDelegate {
	func  pageChanged() {
		pageControl.currentPage = infiniteCarousel.getCurrentSlideIndex()
	}
}
```
