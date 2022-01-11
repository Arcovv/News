import Foundation
import RxSwift
import RxCocoa

public protocol NewsViewModelInputs {
    var viewDidLoad: PublishRelay<()> { get }
    var didTapNews: PublishRelay<News> { get }
}

public protocol NewsViewModelOutputs {
    var news: Driver<[News]> { get }
}

public protocol NewsViewModelType {
    var inputs: NewsViewModelInputs { get }
    var outputs: NewsViewModelOutputs { get }
}

public final class NewsViewModel :
    NewsViewModelInputs,
    NewsViewModelOutputs,
    NewsViewModelType
{
    let coordinator: Coordinator
    let interactor: NewsInteractorType
    let disposeBag = DisposeBag()
    
    public var inputs: NewsViewModelInputs { return self }
    public var outputs: NewsViewModelOutputs { return self }
    
    // MARK: - Inputs
    
    public let viewDidLoad: PublishRelay<()>
    public let didTapNews: PublishRelay<News>
    
    // MARK: - Outputs
    
    public var news: Driver<[News]> {
        return interactor
            .news
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
    }
    
    // MARK: - Init
    
    public init(coordinator: Coordinator, interactor: NewsInteractorType) {
        self.coordinator = coordinator
        self.interactor = interactor
        
        let viewDidLoad = PublishRelay<()>()
        
        self.didTapNews = PublishRelay()
        self.viewDidLoad = viewDidLoad
        
        viewDidLoad
            .subscribe(onNext: { [unowned interactor] _ in
                interactor.fetchNews()
            })
            .disposed(by: disposeBag)
        
        didTapNews
            .subscribe(onNext: { [unowned self] news in
                let url = URL(string: news.url)!
                let safariCoordinator = SafariCoordinator(
                    url: url,
                    navigationController: self.coordinator.navigationController
                )
                safariCoordinator.start()
            })
            .disposed(by: disposeBag)
    }
    
}
