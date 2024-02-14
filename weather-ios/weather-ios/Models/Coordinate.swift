//
//  Coordinate.swift
//  weather-ios
//
//  Created by JiHoon K on 2/7/24.
//


struct Coordinate: Decodable {
    let lat: Double
    let lon: Double
    var localNames: LocalNames?
    
    struct LocalNames: Decodable {
        let en: String?
        let ko: String?
    }
    
    private enum CodingKeys: String, CodingKey {
        case lat, lon
        case localNames = "local_names"
    }
}
