import class UIKit.UINavigationController

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}

final class NewsCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
//        let newsInteractor = MockNewsInteractor()
        let newsInteractor = NewsInteractor()
        let newsViewModel = NewsViewModel(coordinator: self, interactor: newsInteractor)
        let newsViewController = NewsViewController(viewModel: newsViewModel)

        navigationController.pushViewController(newsViewController, animated: true)
    }
}
