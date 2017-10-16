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
                var windSpeed : Double = 0.0;
                
                var code : Int = 0;
                
                // Seems to be an error in the openweather API that misspells 'code'
                if let invalidCode = jsonResult["cod"] as? Int {
                    code = invalidCode;
                } else {
                    if let validCode = jsonResult["cod"] as? Int {
                        code = validCode;
                    }
                }
                if (code != 200) {
                    if let message = jsonResult["message"] as? String {
                        
                        Log.w ("Unable to fetch weather info with code: \(code) and message: \(message)")
                    }
                    return nil;
                }
                
                if let weatherArrayJson : NSArray = jsonResult["weather"] as? NSArray {
                    if let weatherJson : NSDictionary = weatherArrayJson.object(at: 0) as? NSDictionary {
                        weather = weatherJson;
                    }
                }
                if let windJson : NSDictionary = jsonResult["wind"] as? NSDictionary {
                    windSpeed = windJson["speed"] as! Double;
                }
                if let mainJson : NSDictionary = jsonResult["main"] as? NSDictionary {
                    main = mainJson;
                }
                let weatherId = weather["id"] as! NSNumber
                let currentTemp = main["temp"] as! NSNumber
                
                let maxTemp = main["temp_max"] as! NSNumber
                let minTemp = main["temp_min"] as! NSNumber
                return Weather.init(description: weather["description"] as! String, icon: weather["icon"] as! String, id: weatherId.intValue, main: weather["main"] as! String, temperature: currentTemp.intValue, maxTemperature: maxTemp.intValue, minTemperature: minTemp.intValue, windSpeed: windSpeed, location: location, updateDate: Date());
            }
        } catch {
            Log.e("Error!! Unable to parse json")
        }
        return nil;
    }
}
