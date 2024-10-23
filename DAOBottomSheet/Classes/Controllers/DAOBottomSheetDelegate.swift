//
//  DAOBottomSheetDelegate.swift
//  DAOBottomSheet
//
//  Created by DAO on 2022/1/8.
//

import UIKit

/// Setup bottom sheet related views and handle actions.
public protocol DAOBottomSheetDelegate: AnyObject {
    
    /// Added your custom content UI on contentView.
    func setupDAOBottomSheetContentUI(bottomSheet: DAOBottomSheetViewController) -> UIView?
    
    /// You can use your own custom scroll view as bottom sheet content scroll view.
    ///
    /// Implement this function will invalidate ``setupDAOBottomSheetContentUI(bottomSheet:)``.
    ///
    /// You should choose implement between ``setupCustomContentScrollView(bottomSheet:)-9wjkz`` and ``setupDAOBottomSheetContentUI(bottomSheet:)``
    /// - Returns: Custom UIScrollView related class.
    func setupCustomContentScrollView(bottomSheet: DAOBottomSheetViewController) -> UIScrollView?
    
    /// A customizable header slot content view.
    ///
    /// Implement this function will show the header slot view below naviagtion header.
    func setupHeaderSlotContent(with bottomSheet: DAOBottomSheetViewController) -> UIView?
    
    /// Footer content view.
    ///
    /// Implement this function will show the footer view at the bottom of bottom sheet.
    func setupFooterContentView(with bottomSheet: DAOBottomSheetViewController) -> UIView?
    
    /// Footer slot content view.
    ///
    /// Implement this function will show the footer slot view above footer content view.
    func setupFooterSlotContent(with bottomSheet: DAOBottomSheetViewController) -> UIView?
    
    
    /// Called when bottom sheet is goning to dismiss.
    func bottomSheetWillDismiss(bottomSheet: DAOBottomSheetViewController)
}

public extension DAOBottomSheetDelegate {
    func setupCustomContentScrollView(bottomSheet: DAOBottomSheetViewController) -> UIScrollView? {
        return nil
    }
    
    func setupHeaderSlotContent(with bottomSheet: DAOBottomSheetViewController) -> UIView? {
        return nil
    }
    
    func setupFooterContentView(with bottomSheet: DAOBottomSheetViewController) -> UIView? {
        return nil
    }
    
    func setupFooterSlotContent(with bottomSheet: DAOBottomSheetViewController) -> UIView? {
        return nil
    }
}
