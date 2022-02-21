//: A UIKit based Playground for presenting user interface

import UIKit
import WebKit
import PlaygroundSupport

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}

class TableViewCell: UITableViewCell {
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!

    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)

        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont(name: "HelveticaNeue", size: 12)

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        titleLabel.leftAnchor.constraint(
            equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 20
        ).isActive = true
        titleLabel.rightAnchor.constraint(
            equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: 20
        ).isActive = true

        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true

        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        subtitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
    }
}


class TableViewController : UITableViewController {
    var petitions: [Petition] = []
    var displayedPetitions: [Petition] = []

    let myCustomCellId = "My Cell"

    var filtered = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: myCustomCellId)

        let urlString: String

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Credit", style: .plain, target: self, action: #selector(creditTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Filter", style: .plain, target: self, action: #selector(filterTapped)
        )

        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        if let url = URL(string: urlString),
           let data = try? Data(contentsOf: url) {
            parse(json: data)
            return
        }

        showError()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCustomCellId, for: indexPath) as! TableViewCell

        cell.titleLabel.text = displayedPetitions[indexPath.row].title
        cell.subtitleLabel.text = displayedPetitions[indexPath.row].body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    private func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            displayedPetitions = petitions
            tableView.reloadData()
        }
    }

    func showError() {
        let ac = UIAlertController(
            title: "Loading error",
            message: "There was a problem loading the feed; please check your connection and try again.",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    @objc func creditTapped() {
        let controller = UIAlertController(
            title: "Credits",
            message: "The data comes from the We The People API of the Whitehouse.",
            preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: "Close", style: .cancel))

        present(controller, animated: true)
    }

    @objc func filterTapped() {
        let controller = UIAlertController(
            title: "Filter", message: nil, preferredStyle: .alert
        )

        var textField: UITextField?

        controller.addTextField {
            textField = $0
        }

        controller.addAction(UIAlertAction(title: "Done", style: .default) { [self] _ in
            if let field = textField, let text = field.text {
                DispatchQueue.global(qos: .background).async {
                    self.displayedPetitions = self.petitions.filter {
                        $0.title.contains(text) || $0.body.contains(text)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                navigationItem.leftBarButtonItem = UIBarButtonItem(
                    title: "Show all", style: .plain, target: self, action: #selector(restoreUnfiltered)
                )
            }
        })

        present(controller, animated: true)
    }

    @objc func restoreUnfiltered() {
        displayedPetitions = petitions
        tableView.reloadData()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Filter", style: .plain, target: self, action: #selector(filterTapped)
        )
    }
}

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let detailItem = detailItem else {
            return
        }

        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-
        scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
    }

}

let tabBarController = UITabBarController()

tabBarController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 568)

let content = UINavigationController(
    rootViewController: TableViewController()
)

let topRated = UINavigationController(
    rootViewController: TableViewController()
)

content.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
topRated.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)

tabBarController.viewControllers = [ content, topRated ]
PlaygroundPage.current.liveView = tabBarController
