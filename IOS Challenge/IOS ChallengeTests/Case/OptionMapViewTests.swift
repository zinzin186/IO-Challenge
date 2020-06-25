//
//  OptionMapViewTests.swift
//  IOS ChallengeTests
//
//  Created by Din Vu Dinh on 6/25/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import XCTest
import UIKit
import RxSwift
import RxCocoa

@testable import IOS_Challenge

class OptionMapViewTests: XCTestCase {

    var optionMapView: OptionMapView!
    func checkRevertButtonEndableCase1(){
        optionMapView = OptionMapView()
        optionMapView.fromLocationTextField.text = ""
        let fromLocationTextFieldIsEmpty = optionMapView.fromLocationTextField.text?.isEmpty ?? true
        let toLocationTextFieldIsEmpty = optionMapView.toLocationTextField.text?.isEmpty ?? true
        let isReverButtonEnable = (!fromLocationTextFieldIsEmpty && !toLocationTextFieldIsEmpty)
        optionMapView.revertButton.isEnabled = isReverButtonEnable
        XCTAssertEqual(optionMapView.revertButton.isEnabled, false)
    }

    func checkRevertButtonEndableCase2(){
        optionMapView = OptionMapView()
        optionMapView.toLocationTextField.text = ""
        let fromLocationTextFieldIsEmpty = optionMapView.fromLocationTextField.text?.isEmpty ?? true
        let toLocationTextFieldIsEmpty = optionMapView.toLocationTextField.text?.isEmpty ?? true
        let isReverButtonEnable = (!fromLocationTextFieldIsEmpty && !toLocationTextFieldIsEmpty)
        optionMapView.revertButton.isEnabled = isReverButtonEnable
        XCTAssertEqual(optionMapView.revertButton.isEnabled, false)
    }
    func checkRevertButtonEndableCase3(){
        optionMapView = OptionMapView()
        optionMapView.toLocationTextField.text = ""
        optionMapView.fromLocationTextField.text = "Hanoi"
        let fromLocationTextFieldIsEmpty = optionMapView.fromLocationTextField.text?.isEmpty ?? true
        let toLocationTextFieldIsEmpty = optionMapView.toLocationTextField.text?.isEmpty ?? true
        let isReverButtonEnable = (!fromLocationTextFieldIsEmpty && !toLocationTextFieldIsEmpty)
        optionMapView.revertButton.isEnabled = isReverButtonEnable
        XCTAssertEqual(optionMapView.revertButton.isEnabled, false)
    }
    func checkRevertButtonEndableCase4(){
        optionMapView = OptionMapView()
        optionMapView.toLocationTextField.text = "Hanoi"
        optionMapView.fromLocationTextField.text = ""
        let fromLocationTextFieldIsEmpty = optionMapView.fromLocationTextField.text?.isEmpty ?? true
        let toLocationTextFieldIsEmpty = optionMapView.toLocationTextField.text?.isEmpty ?? true
        let isReverButtonEnable = (!fromLocationTextFieldIsEmpty && !toLocationTextFieldIsEmpty)
        optionMapView.revertButton.isEnabled = isReverButtonEnable
        XCTAssertEqual(optionMapView.revertButton.isEnabled, false)
    }
    func checkRevertButtonEndableCase5(){
        optionMapView = OptionMapView()
        optionMapView.toLocationTextField.text = "Hanoi"
        optionMapView.fromLocationTextField.text = "Hanoi1"
        let fromLocationTextFieldIsEmpty = optionMapView.fromLocationTextField.text?.isEmpty ?? true
        let toLocationTextFieldIsEmpty = optionMapView.toLocationTextField.text?.isEmpty ?? true
        let isReverButtonEnable = (!fromLocationTextFieldIsEmpty && !toLocationTextFieldIsEmpty)
        optionMapView.revertButton.isEnabled = isReverButtonEnable
        XCTAssertEqual(optionMapView.revertButton.isEnabled, true)
    }
}
