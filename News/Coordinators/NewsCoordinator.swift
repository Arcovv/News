import class UIKit.UINavigationController

public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}

public final class NewsCoordinator: Coordinator {
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
//        let newsInteractor = MockNewsInteractor()
        let newsInteractor = NewsInteractor()
        let newsViewModel = NewsViewModel(coordinator: self, interactor: newsInteractor)
        let newsViewController = NewsViewController(viewModel: newsViewModel)

        navigationController.pushViewController(newsViewController, animated: true)
    }
}
