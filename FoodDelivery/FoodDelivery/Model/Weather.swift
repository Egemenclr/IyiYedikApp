//
//  Weather.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 12.10.2021.
//

import Foundation

struct Weather: Decodable {
  let cityName: String
  let temperature: Int
  let humidity: Int
  let icon: String

  static let empty = Weather(
    cityName: "Unknown",
    temperature: -1000,
    humidity: 0,
    icon: ""
  )

  init(cityName: String,
       temperature: Int,
       humidity: Int,
       icon: String) {
    self.cityName = cityName
    self.temperature = temperature
    self.humidity = humidity
    self.icon = icon
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    cityName = try values.decode(String.self, forKey: .cityName)
    let info = try values.decode([AdditionalInfo].self, forKey: .weather)
    icon = ""

    let mainInfo = try values.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
    temperature = Int(try mainInfo.decode(Double.self, forKey: .temp))
    humidity = try mainInfo.decode(Int.self, forKey: .humidity)
  }

  enum CodingKeys: String, CodingKey {
    case cityName = "name"
    case main
    case weather
  }

  enum MainKeys: String, CodingKey {
    case temp
    case humidity
  }

  private struct AdditionalInfo: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
  }
}
