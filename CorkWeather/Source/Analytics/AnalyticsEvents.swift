//
//  AnalyticsEvents.swift
//  CorkWeather
//
//  Created by Eddie Long on 01/11/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

struct AnalyticsEvents {
    public static let onboardingShown = "onboarding_shown"
    public static let onboardingClicked = "onboarding_clicked"
    public static let addClicked = "add_clicked"
    public static let infoClicked = "info_clicked"
    public static let contactClicked = "contact_clicked"
    public static let showPlacePicker = "show_place_picker"
    public static let placePicked = "place_picked"
    public static let picked_latitude = "picked_latitude"
    public static let picked_longitude = "picked_longitude"
    public static let placePickedError = "place_picked_error"
    public static let weatherLocationFetchFailure = "failed_fetch_weather_location_info"
    public static let databaseLoadFailure = "database_load_failure"
    public static let weatherItemLoadFailure = "weather_item_load_failure"
    public static let errorInfoDetail = "detail"
}
