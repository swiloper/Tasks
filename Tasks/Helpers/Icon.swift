//
//  Icon.swift
//  Tasks
//
//  Created by Ihor Myronishyn on 29.10.2023.
//

import SwiftUI

struct Icon {
    
    // MARK: - Properties
    
    let light: String
    let dark: String
    
    // MARK: - Change
    
    func change(isDark: Bool) {
        if UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons)) && UIApplication.shared.supportsAlternateIcons {
            typealias setAlternateIconNameClosure = @convention(c) (NSObject, Selector, NSString?, @escaping (NSError) -> ()) -> ()

            let title = isDark ? dark : light
            let selector = NSSelectorFromString("_setAlternateIconName:completionHandler:")
            let implementation = UIApplication.shared.method(for: selector)
            let method = unsafeBitCast(implementation, to: setAlternateIconNameClosure.self)
            method(UIApplication.shared, selector, title as NSString?, { _ in })
        }
    }
}
