//
//  ProjetImerirAppTests.swift
//  ProjetImerirAppTests
//
//  Created by Student on 06/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import XCTest
@testable import ProjetImerirApp

class ProjetImerirAppTests: XCTestCase {
    
    var vc = NameModalViewController()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNameCheck() {

        let badNames = ["","l","le test unitaire a 12","Ēric"]
        let goodNames = ["Jean-Yves","Gaetan","Mon prénom"]
        
        for name in badNames {
            let result = vc.getErrorMessage(for: name)
            // Error was returned
            XCTAssertNotNil(result, "Le nom \(name) ne devrait pas être valide.")
        }
        
        for name in goodNames {
            let result = vc.getErrorMessage(for: name)
            // Aucune erreur n'est retournée
            XCTAssertNil(result, "Le nom \(name) devrait être invalide.")
        }
    }
    
}
