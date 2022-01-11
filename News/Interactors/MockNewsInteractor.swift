import Foundation
import RxSwift

public final class MockNewsInteractor: NewsInteractorType {
    public var news: Observable<[News]> {
        return newsSubject.asObservable()
    }
    
    private let newsSubject = BehaviorSubject<[News]>(value: [])

    public init () {
    }
    
    public func fetchNews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let news1 = News()
        news1.url = "https://www.reuters.com/markets/commodities/us-senators-say-cruz-sanctions-nord-stream-2-could-harm-relations-with-germany-2022-01-11/"
        news1.title = "U.S. senators say Cruz sanctions on Nord Stream 2 could harm relations with Germany - Reuters"
        news1.author = .none
        news1.urlToImage = "https://www.reuters.com/resizer/C1yWL0HH9i01Yx5-QZBLgu05Bp8=/1200x628/smart/filters:quality(80)/cloudfront-us-east-2.images.arcpublishing.com/reuters/KTJMSYMDC5PUDF3U6K3ZULVTXA.jpg"
        news1.publishedAt = dateFormatter.date(from: "2022/01/11 19:04")!
        news1.content = "WASHINGTON, Jan 10 (Reuters) - Several Democratic U.S. senators said late on Monday, after meeting with Biden administration officials, that they believe sanctions on Russia's Nord Stream 2 pipeline … [+3694 chars]"
        
        let news2 = News()
        news2.url = "https://www.reuters.com/markets/commodities/us-senators-say-cruz-sanctions-nord-stream-2-could-harm-relations-with-germany-2022-01-11/"
        news2.title = "Sonoma County bans large gatherings, advises residents to shelter in place for next 30 days - San Francisco Chronicle"
        news2.author = "Erin Allday"
        news2.urlToImage = "https://s.hdnux.com/photos/01/23/43/65/21904743/3/rawImage.jpg"
        news2.publishedAt = dateFormatter.date(from: "2022/01/11 19:03")!
        news2.content = "Sonoma County is banning large gatherings anything over 50 people indoors or 100 outdoors and recommending that all residents shelter in place and avoid contact with those outside their households ov… [+2954 chars]"
        
        let items = [news1, news2]
        newsSubject.onNext(items)
    }
}
