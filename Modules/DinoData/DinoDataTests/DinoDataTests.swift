//
//  DinoDataTests.swift
//  DinoDataTests
//
//  Created by 319349 on 28/09/21.
//

import XCTest
@testable import DinoData

class DinoDataTests: XCTestCase {

    func testDinoJson() throws {
        let data = DinoData()
        if let dinos = data.readDinoJSON() {
            XCTAssert(dinos.count > 0) } else { XCTFail() }
        
    }

    func testLorenIpsum() throws {
        let data = DinoData()
        if let lines = data.readLoremIpsum() {
            XCTAssert(lines.count > 0) } else { XCTFail() }
        
    }

}
