import Foundation

struct Article: Decodable {
    let title: String
    let author: String?
    let description: String
    let url: URL
    let urlToImage: URL
    let publishedAt: Date
    let content: String?
}
