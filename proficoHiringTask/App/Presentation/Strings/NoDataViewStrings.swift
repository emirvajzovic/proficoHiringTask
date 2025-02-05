//
//  NoDataView 2.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

extension Strings {
    enum NoDataView {
        static var title: String {
            "Oops!".localized
        }
        static var message: String {
            String(format: "%@\n%@","We're having trouble fetching the data right now.".localized, "Please try again.".localized)
        }
        
        static var buttonTitle: String {
            "Try again".localized
        }
    }
}
