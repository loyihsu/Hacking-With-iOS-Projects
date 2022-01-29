//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

func getLastURLComponent(of path: String) -> String? {
    guard let url = URL(string: path) else { return nil }
    return url.lastPathComponent
}

class TableViewController : UITableViewController {
    var pictures = [String]()

    let myCustomCellId = "myCustomCellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        // This is intended for read app.
        // let fm = FileManager.default
        // let path = Bundle.main.resourcePath!
        // let items = try! fm.contentsOfDirectory(atPath: path)

        // Get the image files in the `Resource` folder in Swift Playground
        pictures = Bundle
            .main
            .paths(forResourcesOfType: "jpg", inDirectory: nil)

        // Register for reuse identifier for later use.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: myCustomCellId)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCustomCellId, for: indexPath)
        let imagePath = pictures[indexPath.row]
        cell.textLabel?.text = getLastURLComponent(of: imagePath)
        cell.imageView?.image = UIImage(contentsOfFile: imagePath)
        return cell
    }
}

class DetailViewController: UIViewController {
    var image: String!

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let imageView = UIImageView()
        view.addSubview(imageView)

        imageView.contentMode = .scaleAspectFit

        imageView.image = UIImage(contentsOfFile: image)

        imageView.translatesAutoresizingMaskIntoConstraints = false

        let imageViewConstraints = [
            NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal,
                               toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal,
                               toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal,
                               toItem: view, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal,
                               toItem: view, attribute: .height, multiplier: 1, constant: 0)
        ]

        NSLayoutConstraint.activate(imageViewConstraints)

        self.view = view
    }
}

// MARK: - Previews

func previewTableViewController() -> UITableViewController {
    return TableViewController()
}

func previewDetailViewController() -> UIViewController {
    let controller = DetailViewController()

    let image = Bundle
        .main
        .paths(forResourcesOfType: "jpg", inDirectory: nil)
        .first!

    controller.image = image

    return controller
}

PlaygroundPage.current.liveView = previewDetailViewController()

