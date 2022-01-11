import Moya
import RealmSwift

public protocol NewsInteractorType: AnyObject {
    func fetchNews(completion: @escaping ([News]) -> Void)
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
}

// MARK: - Implement NewsInteractorType
extension NewsInteractor: NewsInteractorType {
    func fetchNews(completion: @escaping ([News]) -> Void) {
        if let task = self.task {
            if !task.isCancelled {
                task.cancel()
            }
        }
        
        let localNews = Array(
            self.realm.objects(News.self)
                .sorted(by: \News.publishedAt, ascending: false)
        )
        completion(localNews)
        
        self.task = apiProvider.request(NewsApi.topHeadlines(country: "tw")) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let realm = self.realm
                let articles = try! self.decoder.decode(ArticlesResult.self, from: response.data).articles
                let news = articles.map(toNews).sorted { $0.publishedAt > $1.publishedAt }
                
                guard news != localNews else { return}
                
                try! realm.write {
                    realm.add(news, update: .modified)
                }
                
                completion(news)
                
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
