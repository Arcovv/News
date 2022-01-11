import Foundation

struct ArticlesResult: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
