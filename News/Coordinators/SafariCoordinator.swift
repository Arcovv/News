import class UIKit.UINavigationController
import SafariServices

final class SafariCoordinator: Coordinator {
    let url: URL
    var navigationController: UINavigationController
    
    init(url: URL, navigationController: UINavigationController) {
        self.url = url
        self.navigationController = navigationController
    }
    
    func start() {
        let safari = SFSafariViewController(url: url)
        navigationController.present(safari, animated: true, completion: nil)
    }
}
