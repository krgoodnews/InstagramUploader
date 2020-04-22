//
//  InstagramUploaderTests.swift
//  InstagramUploaderTests
//
//  Created by Yunsu Guk on 2020/04/15.
//  Copyright © 2020 Yunsu Guk. All rights reserved.
//

import XCTest
import RxTest
@testable import 스샷그램

class InstagramUploaderTests: XCTestCase {

    // MARK: - ViewModel
    
    func test_viewModel_ratio() {
        let viewModel = ProcessImageViewModel()
        XCTAssertEqual(viewModel.bindableImageRatio.value, .portrait)

        viewModel.ratioTapEvent.accept(())
        XCTAssertEqual(viewModel.bindableImageRatio.value, .landscape)

        viewModel.ratioTapEvent.accept(())
        XCTAssertEqual(viewModel.bindableImageRatio.value, .square)

        viewModel.ratioTapEvent.accept(())
        XCTAssertEqual(viewModel.bindableImageRatio.value, .portrait)
    }

    func test_viewModel_background() {
        let viewModel = ProcessImageViewModel()
        XCTAssertEqual(viewModel.bindableBackground.value, .blur)

        viewModel.backgroundTapEvent.accept(())
        XCTAssertEqual(viewModel.bindableBackground.value, .color(.black))
    }
}
