import XCTest
import UIKit
import News
import RxTest
import RxSwift

class NewsViewModelTests: XCTestCase {
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
            .drive(news)
            .disposed(by: disposeBag)
        
        viewModel.inputs.viewDidLoad.accept(())
        
        // First is [], then emit news
        XCTAssertEqual(news.events.count, 2)
        
        let newsCount = news.events.map { event in event.value.element!.count }
        XCTAssertEqual(newsCount, [0, 2])
    }
}
