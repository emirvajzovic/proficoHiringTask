//
//  GameDetailsViewModel.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 2. 2. 2025..
//

import Combine

class GameDetailsViewModel {
    typealias MetadataInfo = StyleGuide.Components.MetadataView.MetadataInfo
    
    enum ViewState {
        case idle(Presentation.Game)
        case loading
        case success([ViewSection])
        case failure(Error)
    }
    
    enum ViewSection {
        case about(description: String)
        case screenshots(urls: [String])
        case systemRequirements(platform: String, description: String)
        case metadata(_ metadata: [MetadataInfo])
        var title: String? {
            switch self {
            case .about:
                return Strings.GameDetails.Section.about
            case .screenshots:
                return Strings.GameDetails.Section.screenshots
            case .systemRequirements(let platform, _):
                return Strings.GameDetails.Section.systemRequirements(platform: platform)
            case .metadata:
                return nil
            }
        }
    }
    
    enum ViewEvent {
        case getData
    }
    
    @Injected private var useCase: GameDetailsUseCase
    
    @Published var state: ViewState
    private var game: Presentation.Game
    
    init(game: Presentation.Game) {
        self.game = game
        self.state = .idle(game)
    }
    
    func trigger(_ event: ViewEvent) {
        switch event {
        case .getData:
            getData()
        }
    }
}


private extension GameDetailsViewModel {
    func getData() {
        Task {
            state = .loading
            do {
                let data = try await useCase.getDetails(gameId: game.id)
                let screenshots = await getScreenshots()
                let requirements: [Presentation.PlatformRequirements] = data.platforms.compactMap { item in
                    guard
                        let requirements = item.requirements,
                        (requirements.minimum != nil || requirements.recommended != nil)
                    else { return nil }
                    return .init(platformName: item.platform.name, minimum: requirements.minimum, recommended: requirements.recommended)
                }
                
                let gameDetails: Presentation.GameDetails = .init(description: data.description,
                                                                  platforms: data.platforms.map(\.platform.name),
                                                                  requirements: requirements,
                                                                  genres: data.genres.map(\.name),
                                                                  releaseDate: data.released,
                                                                  developers: data.developers.map(\.name),
                                                                  publishers: data.publishers.map(\.name),
                                                                  esrbRating: data.esrbRating?.name,
                                                                  screenshots: screenshots.map(\.image))
                state = .success(configureSections(for: gameDetails))
            } catch(let error) {
                state = .failure(error)
#if DEBUG
                print("Error failed to fetch game details:", error)
#endif
            }
        }
    }
    
    func getGameDetails() async throws -> Domain.GameDetails {
        try await useCase.getDetails(gameId: game.id)
    }
    
    func getScreenshots() async -> [Domain.Screenshot] {
        var screenshots: [Domain.Screenshot] = []
        do {
            screenshots = try await useCase.getScreenshots(gameId: game.id, count: 10)
        } catch (let error) {
            #if DEBUG
            print("Failed to fetch screenshots:", error)
            #endif
        }
        return screenshots
    }
    
    func configureSections(for gameDetails: Presentation.GameDetails) -> [ViewSection] {
        var sections = [ViewSection]()
        
        if gameDetails.description.isEmpty == false {
            sections.append(.about(description: gameDetails.description))
        }
        
        let metadata = constructGameMetadata(for: gameDetails)
        if metadata.isEmpty == false {
            sections.append(.metadata(metadata))
        }
        
        if gameDetails.screenshots.isEmpty == false {
            sections.append(.screenshots(urls: gameDetails.screenshots))
        }
        
        if gameDetails.requirements.isEmpty == false {
            gameDetails.requirements.forEach {
                sections.append(.systemRequirements(platform: $0.platformName, description: $0.description))
            }
        }
        
        return sections
    }
    
    func constructGameMetadata(for gameDetails: Presentation.GameDetails) -> [MetadataInfo] {
        var metadata = [MetadataInfo]()
        if gameDetails.platforms.isEmpty == false {
            let platforms = gameDetails.platforms.commaSeparated
            metadata.append(.init(title: Strings.GameDetails.Metadata.platforms, description: platforms))
        }
        
        if gameDetails.genres.isEmpty == false {
            let genres = game.genres.commaSeparated
            metadata.append(.init(title: Strings.GameDetails.Metadata.genre, description: genres))
        }
        
        if gameDetails.releaseDate.isEmpty == false {
            metadata.append(.init(title: Strings.GameDetails.Metadata.releaseData, description: gameDetails.releaseDate.formattedDate))
        }
        
        if gameDetails.developers.isEmpty == false {
            let developers = gameDetails.developers.commaSeparated
            metadata.append(.init(title: Strings.GameDetails.Metadata.developer, description: developers))
        }
        
        if gameDetails.publishers.isEmpty == false {
            let publishers = gameDetails.publishers.commaSeparated
            metadata.append(.init(title: Strings.GameDetails.Metadata.publisher, description: publishers))
        }

        if let ageRating = gameDetails.esrbRating {
            metadata.append(.init(title: Strings.GameDetails.Metadata.ageRating, description: ageRating))
        }
        
        return metadata
    }
}
