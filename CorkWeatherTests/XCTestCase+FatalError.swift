//
//  XCTestCase+FatalError.swift
//  CorkWeatherTests
//
//  Created by Eddie Long on 15/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
@testable import CorkWeather
import XCTest

extension XCTestCase {
    func expectFatalError(testcase: @escaping () -> Void) {
        
        let expectation = self.expectation(description: "expectingFatalError")
        
        FatalErrorUtil.replaceFatalError { message, _, _ in
            expectation.fulfill()
            self.unreachable()
        }
        
        DispatchQueue.global(qos: .userInitiated).async(execute: testcase)
        
        waitForExpectations(timeout: 2) { _ in
            FatalErrorUtil.restoreFatalError()
        }
    }
    
    private func unreachable() -> Never {
        repeat {
            RunLoop.current.run()
        } while (true)
    }
}
