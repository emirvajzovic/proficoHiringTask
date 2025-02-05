//
//  GamesViewModelTests.swift
//  proficoHiringTaskTests
//
//  Created by Emir Vajzović on 4. 2. 2025..
//

import Combine
import XCTest
@testable import proficoHiringTask

extension DependencyManager {
    static func setupMocks() {
        let container = Container.shared
        container.register(GamesListUseCaseMock(), as: GamesListUseCase.self)
    }
}

protocol GamesViewModelMockProvider {
    var gamesListUseCaseMock: GamesListUseCaseMock { get }
}

extension GamesViewModelMockProvider {
    var gamesListUseCaseMock: GamesListUseCaseMock {
        Container.shared.resolve(GamesListUseCase.self) as! GamesListUseCaseMock
    }
}

final class GamesViewModelTests: XCTestCase, GamesViewModelMockProvider {
    var sut: GamesViewModel!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        DependencyManager.setupMocks()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        sut = nil
        super.tearDown()
    }
    
    func testDataFetchSuccessful() {
        let stubbedData = Domain.mockGame()
        let expectation = expectation(description: #function)
        sut = GamesViewModel()
        var observedStates: [GamesViewModel.ViewState] = []
        gamesListUseCaseMock.executeReturnValues = [stubbedData]
        
        sut.$state
            .sink { state in
                observedStates.append(state)
                if case let .success(items, _) = state, let item = items.first {
                    XCTAssertEqual(self.gamesListUseCaseMock.executeCallCount, 1)
                    XCTAssertEqual(item.id, stubbedData.id)
                    XCTAssertEqual(item.name, stubbedData.name)
                    XCTAssertEqual(items.count, 1)
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        
        sut.trigger(.getData)
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(observedStates.count, 3)
        XCTAssertEqual(observedStates[0], .idle)
        XCTAssertEqual(observedStates[1], .loading)
        XCTAssertEqual(observedStates[2], .success([], forceReload: false))
    }
    
    func testDataFetchFailed() {
        let expectation = expectation(description: #function)
        sut = GamesViewModel()
        var observedStates: [GamesViewModel.ViewState] = []
        
        sut.$state
            .sink { state in
                observedStates.append(state)
                if case .failure = state {
                    XCTAssertEqual(self.gamesListUseCaseMock.executeCallCount, 1)
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.trigger(.getData)
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(observedStates.count, 3)
        XCTAssertEqual(observedStates[0], .idle)
        XCTAssertEqual(observedStates[1], .loading)
        XCTAssertEqual(observedStates[2], .failure(nil))
    }
    
    func testFetchMoreDataSuccessful() {
        let stubbedData = [Domain.mockGame(), Domain.mockGame(id: 2)]
        let fetchDataExpectation = expectation(description: "Initial data fetch")
        let fetchMoreDataExpectation = expectation(description: "Fetch more data")
        
        gamesListUseCaseMock.executeReturnValues = [stubbedData[0]]
        
        sut = GamesViewModel()
        var observedStates: [GamesViewModel.ViewState] = []
        var localCallCounter = 0
        
        sut.$state
            .sink { state in
                observedStates.append(state)
                guard case let .success(items, _) = state else { return }
                if localCallCounter == 1 {
                    XCTAssertEqual(self.gamesListUseCaseMock.executeCallCount, localCallCounter)
                    XCTAssertEqual(self.gamesListUseCaseMock.executeParams[0].page, 1)
                    XCTAssertEqual(items.count, 1)
                    XCTAssertEqual(items[0].id, stubbedData[0].id)
                    XCTAssertEqual(items[0].name, stubbedData[0].name)
                    fetchDataExpectation.fulfill()
                } else if localCallCounter == 2 {
                    XCTAssertEqual(self.gamesListUseCaseMock.executeCallCount, localCallCounter)
                    XCTAssertEqual(self.gamesListUseCaseMock.executeParams[1].page, 2)
                    XCTAssertEqual(items.count, 1)
                    XCTAssertEqual(items[0].id, stubbedData[1].id)
                    XCTAssertEqual(items[0].name, stubbedData[1].name)
                    fetchMoreDataExpectation.fulfill()
                } else {
                    XCTFail()
                }
            }.store(in: &cancellables)
        
        localCallCounter += 1
        sut.trigger(.getData)
        wait(for: [fetchDataExpectation], timeout: 1.0)
        
        gamesListUseCaseMock.executeReturnValues = [stubbedData[1]]
        
        localCallCounter += 1
        sut.trigger(.getNextPageData)
        wait(for: [fetchMoreDataExpectation], timeout: 1.0)
        
        XCTAssertEqual(observedStates.count, 5)
        XCTAssertEqual(observedStates[0], .idle)
        XCTAssertEqual(observedStates[1], .loading)
        XCTAssertEqual(observedStates[2], .success([], forceReload: false))
        XCTAssertEqual(observedStates[3], .loading)
        XCTAssertEqual(observedStates[4], .success([], forceReload: false))
    }
    
    func testFetchMoreDataFailed() {
        let stubbedData = Domain.mockGame()
        let fetchDataExpectation = expectation(description: "Initial data fetch")
        let fetchMoreDataExpectation = expectation(description: "Fetch more data")
        
        gamesListUseCaseMock.executeReturnValues = [stubbedData]
        
        sut = GamesViewModel()
        var observedStates: [GamesViewModel.ViewState] = []
        
        sut.$state
            .sink { state in
                observedStates.append(state)
                if case let .success(items, _) = state {
                    XCTAssertEqual(self.gamesListUseCaseMock.executeCallCount, 1)
                    XCTAssertEqual(items.count, 1)
                    fetchDataExpectation.fulfill()
                } else if case .failure = state {
                    XCTAssertEqual(self.gamesListUseCaseMock.executeCallCount, 2)
                    fetchMoreDataExpectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.trigger(.getData)
        wait(for: [fetchDataExpectation], timeout: 1.0)
        
        gamesListUseCaseMock.executeReturnValues = nil
        
        sut.trigger(.getNextPageData)
        wait(for: [fetchMoreDataExpectation], timeout: 1.0)
        
        XCTAssertEqual(observedStates.count, 5)
        XCTAssertEqual(observedStates[0], .idle)
        XCTAssertEqual(observedStates[1], .loading)
        XCTAssertEqual(observedStates[2], .success([], forceReload: false))
        XCTAssertEqual(observedStates[3], .loading)
        XCTAssertEqual(observedStates[4], .failure(nil))
    }
    
    func testReloadDataSuccessful() {
        let stubbedData = Domain.mockGame()
        let expectation = expectation(description: #function)
        sut = GamesViewModel()
        var observedStates: [GamesViewModel.ViewState] = []
        gamesListUseCaseMock.executeReturnValues = [stubbedData]
        
        sut.$state
            .sink { state in
                observedStates.append(state)
                if case let .success(items, reload) = state, let item = items.first {
                    XCTAssertTrue(reload)
                    XCTAssertEqual(self.gamesListUseCaseMock.executeCallCount, 1)
                    XCTAssertEqual(item.id, stubbedData.id)
                    XCTAssertEqual(item.name, stubbedData.name)
                    XCTAssertEqual(items.count, 1)
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        
        sut.trigger(.reloadData)
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(observedStates.count, 2)
        XCTAssertEqual(observedStates[0], .idle)
        XCTAssertEqual(observedStates[1], .success([], forceReload: false))
    }
    
    func testOpenGameDetails() {
        let stubbedData = Presentation.Game(id: 1, name: "Test", backgroundImage: "", platforms: [], genres: [])
        let expectation = expectation(description: #function)
        sut = GamesViewModel()
        
        sut.onResult
            .sink { result in
                switch result {
                case .presentGameDetails(let game):
                    XCTAssertEqual(game, stubbedData)
                    expectation.fulfill()
                case .presentSettings:
                    XCTFail()
                }
            }.store(in: &cancellables)
        
        sut.trigger(.openGameDetails(stubbedData))
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testOpenSettings() {
        let expectation = expectation(description: #function)
        sut = GamesViewModel()
        
        sut.onResult
            .sink { result in
                switch result {
                case .presentGameDetails:
                    XCTFail()
                case .presentSettings:
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.trigger(.openSettings)
        wait(for: [expectation], timeout: 1.0)
    }
}

extension Domain {
    static func mockGame(
        id: Int = 1,
        name: String = "Test",
        backgroundImage: String = "",
        parentPlatforms: [Platforms] = [],
        genres: [Genre] = []
    ) -> Game {
        return Game(id: id, name: name, backgroundImage: backgroundImage, parentPlatforms: parentPlatforms, genres: genres)
    }
}

extension GamesViewModel.ViewState: @retroactive Equatable {
    public static func ==(lhs: GamesViewModel.ViewState, rhs: GamesViewModel.ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
            (.loading, .loading),
            (.failure, .failure),
            (.success, .success):
            return true
        default:
            return false
        }
    }
}
