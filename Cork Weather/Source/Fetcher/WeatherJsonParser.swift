//
//  WeatherJsonParser.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

struct WeatherJsonParser {
    public func parse(jsonData : NSData) -> Weather! {
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
                        print ("Unable to fetch weather info with code: \(code) and message: \(message)")
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
                return Weather(description: weather["description"] as! String, icon: weather["icon"] as! String, id: weather["id"] as! Int, main: weather["main"] as! String, temperature: main["temp"] as! Int, maxTemperature: main["temp_max"] as! Int,minTemperature: main["temp_min"] as! Int, windSpeed: windSpeed);
            }
        } catch {
            print("Error!! Unable to parse json")
        }
        return nil;
    }
}
