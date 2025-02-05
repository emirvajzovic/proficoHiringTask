//
//  ScreenshotMapper.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 1. 2. 2025..
//

struct ScreenshotMapper {
    static func map(from screenshot: Data.Screenshot) -> Domain.Screenshot {
        return .init(id: screenshot.id, image: screenshot.image)
    }
    
    static func map(from screenshots: Data.Screenshots) -> [Domain.Screenshot] {
        return screenshots.results.map { map(from: $0) }
    }
}
