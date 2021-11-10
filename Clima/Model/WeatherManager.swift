//
//  WeatherManager.swift
//  Clima
//
//  Created by Sarosh Tahir on 08/11/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel)
    func didFailWithError(error:Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=aa6bd3acf1b0178c2a2a1f9bb6e09c76&units=metric"
    
    var delegate:WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with:urlString)
//        print(urlString)
    }
    func fetchWeather(longitude:CLLocationDegrees,latitude:CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString:String){

        //        creates url
        if let url = URL(string: urlString){

            //            creates session
            let session = URLSession(configuration: .default)

            //            give session a task
            let task = session.dataTask(with: url){(data,response,error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                if let safeData = data {
        //            data from the url
                    if let weather = self.parseJSON(safeData){
//                        let weatherVC = WeatherViewController()
                        self.delegate?.didUpdateWeather(self, weather: weather)}
                    
                }
            }
            
            //            start task
            task.resume()
            
        }
    }
    func parseJSON(_ weatherData:Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
//            print("Temprature: \(decodedData.main.temp)")
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionID: id, cityName: name, temprature: temp)
            return weather

        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    func didUpdateWeather(weather:WeatherModel){
        print(weather.temprature)
    }
}
