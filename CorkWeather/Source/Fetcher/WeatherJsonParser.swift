//
//  WeatherJsonParser.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import SWLogger

struct WeatherJsonParser {
    public func parse(location: WeatherLocation, jsonData : NSData) -> Weather! {
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) as? NSDictionary {
                var weather : NSDictionary!
                var main : NSDictionary!
                var windSpeed : Double = 0.0
                
                let code = getStatusCode(json: jsonResult)
                if (code != 200) {
                    if let message = jsonResult["message"] as? String {
                        Log.w ("Unable to fetch weather info with code: \(code) and message: \(message)")
                    }
                    return nil
                }
                
                if let weatherArrayJson : NSArray = jsonResult["weather"] as? NSArray {
                    if let weatherJson : NSDictionary = weatherArrayJson.object(at: 0) as? NSDictionary {
                        weather = weatherJson
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
                
                if let windJson : NSDictionary = jsonResult["wind"] as? NSDictionary {
                    if let speed = windJson["speed"] as? Double {
                        windSpeed = speed
                    }
                }
                if let mainJson : NSDictionary = jsonResult["main"] as? NSDictionary {
                    main = mainJson
                } else {
                    return nil
                }
                
                if let weatherId = weather["id"] as? NSNumber,
                    let currentTemp = main["temp"] as? NSNumber,
                    let maxTemp = main["temp_max"] as? NSNumber,
                    let minTemp = main["temp_min"] as? NSNumber,
                    let icon = weather["icon"] as? String,
                    let description = weather["description"] as? String,
                    let main = weather["main"] as? String {
                    return Weather.init(description: description, icon: icon, id: weatherId.intValue, main: main, temperature: WeatherTemperature(round(currentTemp.doubleValue)), maxTemperature: WeatherTemperature(round(maxTemp.doubleValue)), minTemperature: WeatherTemperature(round(minTemp.doubleValue)), windSpeed: windSpeed, location: location, updateDate: Date())
                } else {
                    return nil
                }
            }
        } catch {
            Log.e("Error!! Unable to parse json")
        }
        return nil
    }
    
    private func getStatusCode(json: NSDictionary) -> Int {
        var code : Int = 0
        
        // Seems to be an error in the openweather API that misspells 'code'
        if let invalidCode = json["cod"] as? Int {
            code = invalidCode
        } else {
            if let validCode = json["cod"] as? Int {
                code = validCode
            }
        }
        return code
    }
}
