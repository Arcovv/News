import Foundation
import RealmSwift

public final class News: Object {
    @Persisted(primaryKey: true)
    var url: String
    
    @Persisted
    var title: String
    
    @Persisted
    var author: String?

    @Persisted
    var urlToImage: String
    
    @Persisted
    var publishedAt: Date
    
    @Persisted
    var content: String?
}
