# ``DAOBottomSheet/DAOBottomSheet``

`DAOBottomSheet` is the main entry class for bottom sheet composite component. It contains navigation controller and content view controller(as navigation root VC). The class also controls the pan gestures and show/dismiss behaviors.

## Overview

Bottom sheets are surfaces containing supplementary content that are anchored to the bottom of the screen.

![Bottom Sheet](bottom-sheet.png)

#### Relationships

![Relationships](bottom-sheet-relationships.png)

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

If you have a custom scroll view(or table view, collection view, etc), implement ``DAOBottomSheetDelegate/setupCustomContentScrollView(bottomSheet:)-58oka`` instead.

```swift
func setupCustomContentScrollView(bottomSheet: DAOBottomSheetViewController) -> UIScrollView? {
    return <#YourCustomScrollableView#>
}

```

## See Also

- ``DAOBottomSheetNavigationController``
- ``DAOBottomSheetViewController``
