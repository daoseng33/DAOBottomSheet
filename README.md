# DAOBottomSheet

[![Version](https://img.shields.io/cocoapods/v/DAOBottomSheet.svg?style=flat)](https://cocoapods.org/pods/DAOBottomSheet)
[![License](https://img.shields.io/cocoapods/l/DAOBottomSheet.svg?style=flat)](https://cocoapods.org/pods/DAOBottomSheet)
[![Platform](https://img.shields.io/cocoapods/p/DAOBottomSheet.svg?style=flat)](https://cocoapods.org/pods/DAOBottomSheet)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Overview
https://github.com/user-attachments/assets/3800cac0-9b42-4f99-9a4b-4bf495e8be23

![bottom-sheet-relationships](https://github.com/user-attachments/assets/8a18772f-d221-45af-93a4-076723e183c0)

## Usage
Hold bottom sheet as a local reference.

```swift
var bottomSheet: DAOBottomSheet?
```

Create bottom sheet via ``DAOBottomSheet/init(parentVC:title:type:)``.

```swift
bottomSheet = DAOBottomSheet(parentVC: self, title: "Title", type: .flexible)
bottomSheet?.rootVC.delegate = self
bottomSheet?.show()
```

Simply add your custom view via delegation function ``DAOBottomSheetDelegate/setupDAOBottomSheetContentUI(bottomSheet:)``.

```swift
func setupDAOBottomSheetContentUI(bottomSheet: DAOBottomSheetViewController) -> UIView? {
    let view = UIView()
    
    contentView.addSubview(view)

    view.snp.makeConstraints {
        $0.height.equalTo(200)
    }

    return view
}
```

If you have a custom scroll view(or table view, collection view, etc), implement ``DAOBottomSheetDelegate/setupCustomContentScrollView(bottomSheet:)`` instead.

```swift
func setupCustomContentScrollView(bottomSheet: DAOBottomSheetViewController) -> UIScrollView? {
    return <#YourCustomScrollableView#>
}

```

## Requirements
iOS 15+

## Installation

DAOBottomSheet is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DAOBottomSheet'
```

## Author

daoseng33, daoseng33@gmail.com

## License

DAOBottomSheet is available under the MIT license. See the LICENSE file for more info.
