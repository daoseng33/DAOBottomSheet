//
//  DAOBottomSheetFooterViewDelegate.swift
//  DAOBottomSheet
//
//  Created by DAO on 2021/12/23.
//

import UIKit

/// Setup footer content view and slot content view.
public protocol DAOBottomSheetFooterViewDelegate: AnyObject {
    func setupContentView() -> UIView?
    func setupSlotContent() -> UIView?
}

public extension DAOBottomSheetFooterViewDelegate {
    func setupContentView() -> UIView? {
        return nil
    }
    
    func setupSlotContent() -> UIView? {
        return nil
    }
}
