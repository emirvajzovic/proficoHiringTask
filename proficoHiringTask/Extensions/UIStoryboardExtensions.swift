//
//  UIStoryboardExtensions.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

import UIKit

extension UIStoryboard {
    static var launchScreen: UIViewController {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LaunchScreen")
    }
}
