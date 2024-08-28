//
//  DAOResources.swift
//  DAOBottomSheet
//
//  Created by DAO on 2019/10/31.
//

import UIKit

final class DAOResources {
    
    enum BundleError: Error {
        case invalidPath
    }
    
    static func bundle() throws -> Bundle {
        // For cocoapods resources.
        // see more: https://juejin.im/post/5a77fb8df265da4e99576702
        let bundle = Bundle(for: DAOResources.self)
        let assetsBundleName = "/DAOBottomSheet.bundle"
        
        guard let resourceBundlePath = bundle.resourcePath?.appending(assetsBundleName), let resourceBundle = Bundle(path: resourceBundlePath) else {
            
#if SWIFT_PACKAGE
            return Bundle.module
#else
            throw BundleError.invalidPath
#endif
        }
        
        return resourceBundle
    }
}
