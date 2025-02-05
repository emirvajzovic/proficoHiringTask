//
//  PlatformRequirementsPresentation.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

extension Presentation {
    struct PlatformRequirements {
        let platformName: String
        let minimum: String?
        let recommended: String?
        
        var description: String {
            let min = minimum ?? .init()
            let rec = recommended ?? .init()
            return [min, rec].joined(separator: "\n\n")
        }
    }
}
