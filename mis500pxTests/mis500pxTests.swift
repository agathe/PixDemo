//
//  mis500pxTests.swift
//  mis500pxTests
//
//  Created by Agathe Battestini on 10/23/15.
//  Copyright © 2015 Misberri. All rights reserved.
//

import XCTest
@testable import mis500px

let randomUrl = "https://pacdn.500px.org/257887/58f5caac4ae39270525777cccfe9b3619d5ba281/1.jpg?0"

class mis500pxTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserName() {
        let user = MISUserModel( "victor", "hugo")
        XCTAssertEqual(user.name, "victor hugo")
        XCTAssertEqual(user.firstname, "victor")
        XCTAssertEqual(user.lastname, "hugo")
    }
    
    func testPhotoUrlNotEmpty(){
        let user = MISUserModel( "victor", "hugo")
        let photo = MISPhotoModel(name: "Beautiful photo", user: user, surl: randomUrl)
        XCTAssertEqual(photo.name, "Beautiful photo")
        XCTAssertEqual(photo.url?.absoluteString, randomUrl)
    }

    func testPhotoUrlEmpty(){
        let user = MISUserModel( "victor", "hugo")
        let photo = MISPhotoModel(name: "Beautiful photo", user: user, surl: nil)
        XCTAssertEqual(photo.name, "Beautiful photo")
        XCTAssertNil(photo.url?.absoluteString)
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
