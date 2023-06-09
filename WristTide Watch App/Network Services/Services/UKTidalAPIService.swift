//
//  UKTidalAPIService.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 13/04/2023.
//

import Foundation
import GeoJSON

protocol UKTidalAPI {
    func getStations() async throws -> [TideStation]
    func getStation(stationId:String) async throws -> TideStation
    func getTidalEvents(stationId:String) async throws -> TidalEvents
}

public class UKTidalAPIService:UKTidalAPI,NetworkService {
    var session: URLSession
    var baseUrl: String
    var urlHelper: URLHelper
    
    init(session: URLSession, baseUrl: String, urlHelper: URLHelper) {
        self.session = session
        self.baseUrl = baseUrl
        self.urlHelper = urlHelper
    }
    
    func getSession() -> URLSession {
        
        guard let subscriptionKey = ProcessInfo.processInfo.environment["Ocp-Apim-Subscription-Key"] else {
            return URLSession.shared
        }
            
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Ocp-Apim-Subscription-Key":subscriptionKey]
        
        let session = URLSession(configuration: config)
        
        return session
    }
    
    func getStations() async throws -> [TideStation] {
        
        let result = await self.fetchData(method: .get, path: "/uktidalapi/api/V1/Stations", responseModel: FeatureCollection.self)

        switch result {
        case .success(let response):
            
            let features = response.features
            var stations = TideStations()
            for feature in features {
                let tideStation = TideStation(feature: feature)
                stations.append(tideStation)
            }
            return stations
            
        case .failure(let error):
            throw error
        }
        
    }
    
    func getStation(stationId:String) async throws -> TideStation {
        
        let result = await self.fetchData(method: .get, path: "/uktidalapi/api/V1/Stations/\(stationId)", responseModel: Feature.self)
                
        switch result {
        case .success(let response):
            let tideStation = TideStation(feature: response)
            return tideStation
        case .failure(let error):
            throw error
        }
        
    }
    
    func getTidalEvents(stationId:String) async throws -> TidalEvents {
        
        let result = await self.fetchData(method: .get, path: "/uktidalapi/api/V1/Stations/\(stationId)/TidalEvents", responseModel: TidalEvents.self)
                
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
        
    }
}
