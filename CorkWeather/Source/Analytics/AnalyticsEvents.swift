//
//  AnalyticsEvents.swift
//  CorkWeather
//
//  Created by Eddie Long on 01/11/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

public struct AnalyticsEvents {
    static let onboardingShown = "onboarding_shown"
    static let onboardingClicked = "onboarding_clicked"
    static let addClicked = "add_clicked"
    static let infoClicked = "info_clicked"
    static let contactClicked = "contact_clicked"
    static let showPlacePicker = "show_place_picker"
    static let placePicked = "place_picked"
    static let pickedLatitude = "picked_latitude"
    static let pickedLongitude = "picked_longitude"
    static let placePickedError = "place_picked_error"
    static let weatherLocationFetchFailure = "failed_fetch_weather_location_info"
    static let databaseLoadFailure = "database_load_failure"
    static let weatherItemLoadFailure = "weather_item_load_failure"
    static let errorInfoDetail = "detail"
}
