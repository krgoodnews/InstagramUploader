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

    func test_뷰모델_생성시_Ratio_초기값은_Portrait() {
        let viewModel = ProcessImageViewModel()
        XCTAssertEqual(viewModel.bindableImageRatio.value, .portrait)
    }

    func test_Ratio버튼_한번_누르면_landscape() {
        let viewModel = ProcessImageViewModel()
        viewModel.ratioTapEvent.accept(())
        XCTAssertEqual(viewModel.bindableImageRatio.value, .landscape)
    }

    func test_Ratio버튼_두번_누르면_square() {
        let viewModel = ProcessImageViewModel()

        viewModel.ratioTapEvent.accept(())
        viewModel.ratioTapEvent.accept(())

        XCTAssertEqual(viewModel.bindableImageRatio.value, .square)
    }

    func test_Ratio버튼_세번_누르면_다시_portrait() {
        let viewModel = ProcessImageViewModel()

        viewModel.ratioTapEvent.accept(())
        viewModel.ratioTapEvent.accept(())
        viewModel.ratioTapEvent.accept(())

        XCTAssertEqual(viewModel.bindableImageRatio.value, .portrait)
    }

}
