import Foundation
import RxSwift
import RxCocoa

public protocol NewsViewModelInputs {
    var viewDidLoad: PublishRelay<()> { get }
    var didTapNews: PublishRelay<News> { get }
}

public protocol NewsViewModelOutputs {
    var news: Signal<[News]> { get }
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
    
    public var news: Signal<[News]> {
        return _newsSubject.asSignal(onErrorJustReturn: [])
    }
    private let _newsSubject = PublishSubject<[News]>()
    
    // MARK: - Init
    
    public init(coordinator: Coordinator, interactor: NewsInteractorType) {
        self.coordinator = coordinator
        self.interactor = interactor
        
        let viewDidLoad = PublishRelay<()>()
        
        self.didTapNews = PublishRelay()
        self.viewDidLoad = viewDidLoad
        
        viewDidLoad
            .subscribe(onNext: { [unowned interactor, self] _ in
                interactor.fetchNews { news in
                    self._newsSubject.onNext(news)
                }
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
