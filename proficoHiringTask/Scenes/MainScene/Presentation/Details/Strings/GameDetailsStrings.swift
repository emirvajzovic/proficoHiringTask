//
//  GameDetails.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//

extension Strings {
    enum GameDetails {
        enum Section {
            static var about: String {
                "About".localized
            }
            static var screenshots: String {
                "Screenshots".localized
            }
            static func systemRequirements(platform: String) -> String {
                String(format: "%@ %@", "System requirements for".localized, platform)
            }
        }
        
        enum Metadata {
            static var platforms: String {
                "Platforms".localized
            }
            static var genre: String {
                "Genre".localized
            }
            static var releaseData: String {
                "Release date".localized
            }
            static var developer: String {
                "Developer".localized
            }
            static var publisher: String {
                "Publisher".localized
            }
            static var ageRating: String {
                "Age rating".localized
            }
        }
    }
}
