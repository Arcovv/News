import UIKit
import RxSwift

final class NewsViewController: UITableViewController {
    let viewModel: NewsViewModelType

    fileprivate var news: [News] = []
    fileprivate let disposeBag = DisposeBag()
    
    init(viewModel: NewsViewModelType) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        view.backgroundColor = .white
        
        self.tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsTableViewCell")
        
        viewModel.outputs.news
            .drive(onNext: { [weak self] news in
                guard let self = self else { return }

                self.news = news
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.inputs.viewDidLoad.accept(())
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        let news = news[indexPath.row]
        cell.setModel(news)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        
        let news = news[indexPath.row]
        viewModel.inputs.didTapNews.accept(news)
    }
}

