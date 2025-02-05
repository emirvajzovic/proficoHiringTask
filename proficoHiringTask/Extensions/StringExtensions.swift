//
//  StringExtensions.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

import Foundation

extension String {
    var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        guard let date = formatter.date(from: self) else { return self }

        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .none
        outputFormatter.locale = Locale(identifier: "en_US")
        
        return outputFormatter.string(from: date)
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
