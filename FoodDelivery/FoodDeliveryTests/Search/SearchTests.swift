import XCTest
import RxSwift
import RxTest
import RxCocoa

@testable import FoodDelivery


class SearchTests: XCTestCase {
    var scheduler: TestScheduler!
    var inputs: SearchViewModelInput!
    var outputs: SearchViewModelOutput!
    var viewModel: SearchViewModel!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        
    }

    override func tearDownWithError() throws {
        scheduler = nil
        inputs = nil
        outputs = nil
        viewModel = nil
        disposeBag = nil
        try super.tearDownWithError()
    }
    
    func test__all_restaurants() {
        let api = RestaurantAPIClient {
            return self.scheduler.single(5, restaurantSuccessMock().restaurants)
        }
        
        inputs = SearchViewModelInput(
            searchText: scheduler.cold(.next(5, "")),
            networkAPI: api
        )
        viewModel = SearchViewModel(inputs)
        outputs = viewModel.outputs(inputs)
        
        let deneme = restaurantSuccessMock()
        
        XCTAssertTrue(true)
    }
    
    func test__searchResult_with_response() {
        let api = RestaurantAPIClient {
            return self.scheduler.single(5, restaurantSuccessMock().restaurants)
        }
        
        inputs = SearchViewModelInput(
            searchText: scheduler.cold(
                .next(10, "M")
            ),
            networkAPI: api
        )
       
        viewModel = SearchViewModel(inputs)
        outputs = viewModel.outputs(inputs)

        
        let expectedResult = searchResultSuccessWithResponse().restaurants
        
        let searchResult = scheduler.record(source: outputs.restaurant)
        
        scheduler.start()
        
        XCTAssertEqual(searchResult.events, [
            //.next(0, []),
            .next(10, expectedResult)
        ])
    }
    
    func test__searchResult_with_no_response() {
        let api = RestaurantAPIClient {
            return self.scheduler.single(5, restaurantSuccessMock().restaurants)
        }
        
        inputs = SearchViewModelInput(
            searchText: scheduler.cold(
                .next(10, "x")
            ),
            networkAPI: api
        )
        viewModel = SearchViewModel(inputs)
        outputs = viewModel.outputs(inputs)
        
        let expectedResult = searchResultSuccessWithNoResponse().restaurants
        let searchResult = scheduler.record(source: outputs.restaurant)
        
        scheduler.start()
        
        XCTAssertEqual(searchResult.events, [
            .next(10, expectedResult)
        ])
    }

}

func restaurantSuccessMock() -> TestModel {
    try! mockObject(
        TestModel.self,
        file: "fooddelivery_restaurants"
    )
}

func searchResultSuccessWithResponse() -> TestModel {
    try! mockObject(
        TestModel.self,
        file: "fooddelivery_searchResult"
    )
}

func searchResultSuccessWithNoResponse() -> TestModel {
    try! mockObject(
        TestModel.self,
        file: "fooddelivery_empty"
    )
}
