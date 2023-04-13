//
//  WristTide_Watch_App_Admiralty_API_Tests.swift
//  WristTide Watch AppTests
//
//  Created by Ben Reed on 13/04/2023.
//

import XCTest
@testable import WristTide_Watch_App

final class WristTide_Watch_App_Admiralty_API_Tests: XCTestCase {
    
    var ukTidalAPIService:UKTidalAPI!
    
    override func setUpWithError() throws {
        
        guard let subscriptionKey = ProcessInfo.processInfo.environment["Ocp-Apim-Subscription-Key"] else {
            XCTFail("No subscription key found")
            return
        }
            
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Ocp-Apim-Subscription-Key":subscriptionKey]
        
        let session = URLSession(configuration: config)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.ukTidalAPIService = UKTidalAPIService(session: session,
                                                   baseUrl: Bundle.main.object(key: .ukTidalApiBaseUrl),
                                                   urlHelper: URLHelper())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCallWithNoSubscriptionKey() async throws {
        
        self.ukTidalAPIService = UKTidalAPIService(session: URLSession.shared,
                                                   baseUrl: Bundle.main.object(key: .ukTidalApiBaseUrl),
                                                   urlHelper: URLHelper())
        
        do {
            let result = try await self.ukTidalAPIService.getStations()
        } catch NetworkServiceError.httpError(code: let statusCode) {
            XCTAssertTrue(statusCode == 401)
        }
    }
    
    func testGetAllStations() async throws {
        
        do {
            let result = try await self.ukTidalAPIService.getStations()
            XCTAssertNotNil(result)
        } catch {
            XCTFail("API call should succeed")
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
