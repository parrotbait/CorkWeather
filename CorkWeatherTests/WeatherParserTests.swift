//
//  WeatherParserTests.swift
//  CorkWeatherTests
//
//  Created by Eddie Long on 15/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import XCTest
@testable import CorkWeather

class WeatherParserTests: XCTestCase {

    func testEmptyData() {
        let parser = WeatherJsonParser()
        let result = parser.parse(location: WeatherLocation.init(coordinate: WeatherCoordinate.init(latitude: 10, longitude: 10), addressLines: nil, postcode: nil), jsonData: NSData.init())
        XCTAssertNil(result)
    }
    
    func testInvalidJson() {
        let parser = WeatherJsonParser()
        let json = "{sdfdsfsfsdf}"
        let result = parser.parse(location: WeatherLocation.init(coordinate: WeatherCoordinate.init(latitude: 10, longitude: 10), addressLines: nil, postcode: nil), jsonData: json.data(using: String.Encoding.utf8)! as NSData)
        XCTAssertNil(result)
    }
    
    func testInvalidCodeJson() {
        let parser = WeatherJsonParser()
        let json = "{\"code\":100, \"message\":\"Something went wrong\"}"
        let result = parser.parse(location: WeatherLocation.init(coordinate: WeatherCoordinate.init(latitude: 10, longitude: 10), addressLines: nil, postcode: nil), jsonData: json.data(using: String.Encoding.utf8)! as NSData)
        XCTAssertNil(result)
    }
    
    func testInvalidCodJson() {
        // given
        let parser = WeatherJsonParser()
        let json = "{\"cod\":401, \"message\": \"Invalid API key. Please see http://openweathermap.org/faq#error401 for more info.\"}"
        
        // when
        let result = parser.parse(location: WeatherLocation.init(coordinate: WeatherCoordinate.init(latitude: 10, longitude: 10), addressLines: nil, postcode: nil), jsonData: json.data(using: String.Encoding.utf8)! as NSData)
        
        // them
        XCTAssertNil(result)
    }
    
    func testMissingWeather() {
        //  given
        let json =
        """
        {\"coord\":{\"lon\":10,\"lat\":50},\"cod\":200}
        """
        let parser = WeatherJsonParser()
        
        // when
        let result = parser.parse(location: WeatherLocation.init(coordinate: WeatherCoordinate.init(latitude: 10, longitude: 10), addressLines: nil, postcode: nil), jsonData: json.data(using: String.Encoding.utf8)! as NSData)
        
        // then
        XCTAssertNil(result)
    }
    
    func testInvalidWeatherFormatJson() {
        //  given
        let json =
        """
        {\"coord\":{\"lon\":10,\"lat\":50},\"weather\":[[\"test\"]],\"base\":\"stations\",\"visibility\":10000,\"wind\":{\"speed\":7.2,\"deg\":260,\"gust\":12.3},\"clouds\":{\"all\":75},\"dt\":1547551200,\"sys\":{\"type\":1,\"id\":1833,\"message\":0.0024,\"country\":\"DE\",\"sunrise\":1547536350,\"sunset\":1547567211},\"id\":2819564,\"name\":\"Regierungsbezirk Unterfranken\",\"cod\":200}
        """
        let parser = WeatherJsonParser()
        
        // when
        let result = parser.parse(location: WeatherLocation.init(coordinate: WeatherCoordinate.init(latitude: 10, longitude: 10), addressLines: nil, postcode: nil), jsonData: json.data(using: String.Encoding.utf8)! as NSData)
        
        // then
        XCTAssertNil(result)
    }
    
    func testMissingMainJson() {
        //  given
        let json =
        """
        {\"coord\":{\"lon\":10,\"lat\":50},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"base\":\"stations\",\"visibility\":10000,\"wind\":{\"speed\":7.2,\"deg\":260,\"gust\":12.3},\"clouds\":{\"all\":75},\"dt\":1547551200,\"sys\":{\"type\":1,\"id\":1833,\"message\":0.0024,\"country\":\"DE\",\"sunrise\":1547536350,\"sunset\":1547567211},\"id\":2819564,\"name\":\"Regierungsbezirk Unterfranken\",\"cod\":200}
        """
        let parser = WeatherJsonParser()
        
        // when
        let result = parser.parse(location: WeatherLocation.init(coordinate: WeatherCoordinate.init(latitude: 10, longitude: 10), addressLines: nil, postcode: nil), jsonData: json.data(using: String.Encoding.utf8)! as NSData)
        
        // then
        XCTAssertNil(result)
    }
    
    func testMainObjJsonFormat() {
        //  given
        let json =
        """
        {\"coord\":{\"lon\":10,\"lat\":50},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"base\":\"stations\",\"main\":[\"test\"],\"visibility\":10000,\"wind\":{\"speed\":7.2,\"deg\":260,\"gust\":12.3},\"clouds\":{\"all\":75},\"dt\":1547551200,\"sys\":{\"type\":1,\"id\":1833,\"message\":0.0024,\"country\":\"DE\",\"sunrise\":1547536350,\"sunset\":1547567211},\"id\":2819564,\"name\":\"Regierungsbezirk Unterfranken\",\"cod\":200}
        """
        let parser = WeatherJsonParser()
        
        // when
        // We take the lat and lon from the passed in coordinate, rather from the JSON feed
        let result = parser.parse(location: WeatherLocation.init(coordinate: WeatherCoordinate.init(latitude: 10, longitude: 10), addressLines: nil, postcode: nil), jsonData: json.data(using: String.Encoding.utf8)! as NSData)
        
        // then
        XCTAssertNil(result)
    }
    
    func testMainJsonMissingMaxTemp() {
        //  given
        let json =
        """
        {\"coord\":{\"lon\":10,\"lat\":50},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"base\":\"stations\",\"main\":{\"temp\":2.85,\"pressure\":1019,\"humidity\":96,\"temp_min\":2,},\"visibility\":10000,\"wind\":{\"speed\":7.2,\"deg\":260,\"gust\":12.3},\"clouds\":{\"all\":75},\"dt\":1547551200,\"sys\":{\"type\":1,\"id\":1833,\"message\":0.0024,\"country\":\"DE\",\"sunrise\":1547536350,\"sunset\":1547567211},\"id\":2819564,\"name\":\"Regierungsbezirk Unterfranken\",\"cod\":200}
        """
        let parser = WeatherJsonParser()
        
        // when
        // We take the lat and lon from the passed in coordinate, rather from the JSON feed
        let result = parser.parse(location: WeatherLocation.init(coordinate: WeatherCoordinate.init(latitude: 10, longitude: 10), addressLines: nil, postcode: nil), jsonData: json.data(using: String.Encoding.utf8)! as NSData)
        
        // then
        XCTAssertNil(result)
    }
    
    func testValidJson() {
        //  given
        let json =
        """
        {\"coord\":{\"lon\":10,\"lat\":50},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"base\":\"stations\",\"main\":{\"temp\":2.85,\"pressure\":1019,\"humidity\":96,\"temp_min\":2,\"temp_max\":3.5},\"visibility\":10000,\"wind\":{\"speed\":7.2,\"deg\":260,\"gust\":12.3},\"clouds\":{\"all\":75},\"dt\":1547551200,\"sys\":{\"type\":1,\"id\":1833,\"message\":0.0024,\"country\":\"DE\",\"sunrise\":1547536350,\"sunset\":1547567211},\"id\":2819564,\"name\":\"Regierungsbezirk Unterfranken\",\"cod\":200}
        """
        let parser = WeatherJsonParser()
        
        // when
        // We take the lat and lon from the passed in coordinate, rather from the JSON feed
        let result = parser.parse(location: WeatherLocation.init(coordinate: WeatherCoordinate.init(latitude: 10, longitude: 10), addressLines: nil, postcode: nil), jsonData: json.data(using: String.Encoding.utf8)! as NSData)
        
        // then
        XCTAssertNotNil(result)
        if let weather = result {
            XCTAssertEqual(weather.id, 803)
            XCTAssertEqual(weather.location.coordinate.latitude, 10)
            XCTAssertEqual(weather.location.coordinate.longitude, 10)
            XCTAssertEqual(weather.description, "broken clouds")
            XCTAssertEqual(weather.temperature, 3)
            XCTAssertEqual(weather.maxTemperature, 4)
            XCTAssertEqual(weather.minTemperature, 2)
            XCTAssertEqual(weather.icon, "04d")
            XCTAssertEqual(weather.windSpeed, 7.2, accuracy: Double.ulpOfOne)
        }
    }
    
    func testValidJsonMissingWind() {
        //  given
        let json =
        """
        {\"coord\":{\"lon\":10,\"lat\":50},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"base\":\"stations\",\"main\":{\"temp\":2.85,\"pressure\":1019,\"humidity\":96,\"temp_min\":2,\"temp_max\":3.5},\"visibility\":10000,\"clouds\":{\"all\":75},\"dt\":1547551200,\"sys\":{\"type\":1,\"id\":1833,\"message\":0.0024,\"country\":\"DE\",\"sunrise\":1547536350,\"sunset\":1547567211},\"id\":2819564,\"name\":\"Regierungsbezirk Unterfranken\",\"cod\":200}
        """
        let parser = WeatherJsonParser()
        
        // when
        // We take the lat and lon from the passed in coordinate, rather from the JSON feed
        let result = parser.parse(location: WeatherLocation.init(coordinate: WeatherCoordinate.init(latitude: 10, longitude: 10), addressLines: nil, postcode: nil), jsonData: json.data(using: String.Encoding.utf8)! as NSData)
        
        // then
        XCTAssertNotNil(result)
        if let weather = result {
            XCTAssertEqual(weather.id, 803)
            XCTAssertEqual(weather.location.coordinate.latitude, 10)
            XCTAssertEqual(weather.location.coordinate.longitude, 10)
            XCTAssertEqual(weather.description, "broken clouds")
            XCTAssertEqual(weather.temperature, 3)
            XCTAssertEqual(weather.maxTemperature, 4)
            XCTAssertEqual(weather.minTemperature, 2)
            XCTAssertEqual(weather.icon, "04d")
            XCTAssertEqual(weather.windSpeed, 0.0, accuracy: Double.ulpOfOne)
        }
    }
}
