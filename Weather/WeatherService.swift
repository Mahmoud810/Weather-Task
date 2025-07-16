//
//  WeatherService.swift
//  Weather
//
//  Created by Mahmoud on 17/07/2025.
//
import Foundation

class WeatherService {
    let apiKey = "70ecac1e1c7a67facb8c408f13f56580"

    func fetchForecast(for city: String, completion: @escaping ([ForecastEntry]?) -> Void) {
        let urlStr = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlStr) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let forecast = try JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(forecast.list)
            } catch {
                print("Decode error: \(error)")
                completion(nil)
            }
        }.resume()
    }

    func fetchForecastForCoordinates(lat: Double, lon: Double, completion: @escaping ([ForecastEntry]?) -> Void) {
        let urlStr = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlStr) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let forecast = try JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(forecast.list)
            } catch {
                print("Decode error: \(error)")
                completion(nil)
            }
        }.resume()
    }

    func fetchCitySuggestions(query: String, completion: @escaping ([City]) -> Void) {
        let urlStr = "https://api.openweathermap.org/geo/1.0/direct?q=\(query)&limit=5&appid=\(apiKey)"
        guard let url = URL(string: urlStr) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let cities = try JSONDecoder().decode([City].self, from: data)
                completion(cities)
            } catch {
                print("City decode error: \(error)")
            }
        }.resume()
    }
}
