import XCTest
import UIKit
import News
import RxTest
import RxSwift

class NewsTests: XCTestCase {
    var viewModel: NewsViewModelType!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        let navigationController = UINavigationController(nibName: nil, bundle: nil)
        let coordinator = NewsCoordinator(navigationController: navigationController)
        let interactor = MockNewsInteractor()
        
        viewModel = NewsViewModel(coordinator: coordinator, interactor: interactor)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        scheduler = nil
        disposeBag = nil
    }
    
    func testFetchNewsCountIsTwo() throws {
        let news = scheduler.createObserver([News].self)
        
        viewModel.outputs.news
            .emit(to: news)
            .disposed(by: disposeBag)
        
        viewModel.inputs.viewDidLoad.accept(())
        
        // Only emit one next event
        XCTAssertEqual(news.events.count, 1)
        
        let newsCount = news.events
            .flatMap { event in event.value.element! }
            .count
        XCTAssertEqual(newsCount, 2)
    }
}
