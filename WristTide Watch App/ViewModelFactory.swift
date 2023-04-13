//
//  ViewModelFactory.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 12/04/2023.
//

import Foundation

public class ViewModelFactory {
    
    static func makeTideStationListViewModel() -> TideStationListViewModel {
        
        let urlHelper = URLHelper()
        let subscriptionKey = ProcessInfo.processInfo.environment["Ocp-Apim-Subscription-Key"]
            
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Ocp-Apim-Subscription-Key":subscriptionKey ?? ""]
        
        let session = URLSession(configuration: config)
        let tideServiceAPI = UKTidalAPIService(session: session, baseUrl: Bundle.main.object(key: .ukTidalApiBaseUrl), urlHelper: urlHelper)
        
        return TideStationListViewModel(tideStationAPIService: tideServiceAPI)
    }
    
}
