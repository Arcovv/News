import Moya
import RealmSwift
import RxSwift

public protocol NewsInteractorType: AnyObject {
    var news: Observable<[News]> { get }
    
    func fetchNews()
}

final class NewsInteractor {
    /// Fetch top headlines API task
    var task: Cancellable?
    
    /// The API provider
    let apiProvider = MoyaProvider<NewsApi>()
    
    /// Local Realm
    let realm = try! Realm()
    
    /// Default JSON decoder
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    private let newsSubject = BehaviorSubject<[News]>(value: [])
    
    private var newsToken: NotificationToken?
    
    deinit {
        newsToken?.invalidate()
    }
    
    init() {
        let newsToken = self.realm
            .objects(News.self)
            .sorted(byKeyPath: "publishedAt", ascending: false)
            .observe { [weak self] changes in
                guard let self = self else { return }
            
                switch changes {
                case .initial(let items):
                    print("On initial")
                    self.newsSubject.onNext(Array(items))
                    
                case .update(let items, _, _, _):
                    print("On update")
                    self.newsSubject.onNext(Array(items))
                    
                case .error(let err):
                    print("observe news error: \(err)")
                }
            }
        
        self.newsToken = newsToken
    }
}

// MARK: - Implement NewsInteractorType
extension NewsInteractor: NewsInteractorType {
    var news: Observable<[News]> {
        return newsSubject.asObservable()
    }
    
    func fetchNews() {
        if let task = self.task {
            if !task.isCancelled {
                task.cancel()
            }
        }
        
        self.task = apiProvider.request(NewsApi.topHeadlines(country: "tw")) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard (200 ..< 300).contains(response.statusCode) else {
                    print("http status code: \(response.statusCode)")
                    return
                }
                
                let realm = self.realm
                let articles = try! self.decoder.decode(ArticlesResult.self, from: response.data).articles
                let news = articles.map(toNews)
                
                try! realm.write {
                    realm.add(news, update: .modified)
                }
                
            case .failure(let err):
                print("err: \(err)")
            }
        }
    }
}

private func toNews(_ article: Article) -> News {
    let news = News()
    news.title = article.title
    news.author = article.author
    news.url = article.url.absoluteString
    news.urlToImage = article.urlToImage.absoluteString
    news.publishedAt = article.publishedAt
    news.content = article.content
    
    return news
}
