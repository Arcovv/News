import Foundation
import Moya

enum NewsApi {
    static let apiKey = "23dc37975aab471a82dc47d2d0f38516"
    
    case topHeadlines(country: String)
}

extension NewsApi: TargetType {
    var baseURL: URL { URL(string: "https://newsapi.org")! }
    
    var path: String {
        switch self {
        case .topHeadlines(_):
            return "/v2/top-headlines"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .topHeadlines(let country):
            return .requestParameters(
                parameters: ["apiKey": NewsApi.apiKey, "country": country],
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
