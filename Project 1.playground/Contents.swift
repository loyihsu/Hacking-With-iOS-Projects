//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

func getLastURLComponent(of path: String) -> String? {
    guard let url = URL(string: path) else { return nil }
    return url.lastPathComponent
}

struct ImageItem {
    var name: String
    var path: String
}

class TableViewController : UITableViewController {
    var pictures = [ImageItem]()

    let myCustomCellId = "myCustomCellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        // This is intended for real app.
        // let fm = FileManager.default
        // let path = Bundle.main.resourcePath!
        // let images = try! fm.contentsOfDirectory(atPath: path)
        //    .filter({ $0.contains("nssl") })
        //    .map({ "\(path)/\($0)" })

        // Get the image files in the `Resource` folder in Swift Playground

        DispatchQueue.global(qos: .background).async {
            let images = Bundle
                .main
                .paths(forResourcesOfType: "jpg", inDirectory: nil)

            self.pictures = images
                .sorted()
                .enumerated()
                .map({ (offset, path) -> ImageItem in
                    return ImageItem(name: "Picture \(offset + 1) of \(images.count)", path: path)
                })

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        // Register for reuse identifier for later use.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: myCustomCellId)

        title = "Storm Viewer"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(recommend))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCustomCellId, for: indexPath)

        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .bold)

        let imageItem = pictures[indexPath.row]
        cell.textLabel?.text = imageItem.name
        cell.imageView?.image = UIImage(contentsOfFile: imageItem.path)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.image = pictures[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    @objc func recommend(_ sender: UIBarButtonItem!) {
        let ac = UIAlertController(title: "Share this app to your friend", message: "Please share this app to your friend", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "YES!", style: .default, handler: { _ in
            print("YES!")
        }))
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            print("Yes")
        }))
        ac.addAction(UIAlertAction(title: "NOnononoNONo", style: .destructive, handler: {  _ in
            print("Really?")
        }))
        present(ac, animated: true)
    }
}

class DetailViewController: UIViewController {
    var image: ImageItem!

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemBackground

        let imageView = UIImageView()
        view.addSubview(imageView)

        imageView.contentMode = .scaleAspectFit

        imageView.image = UIImage(contentsOfFile: image.path)

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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = image.name
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}

// MARK: - Previews

func previewTableViewController() -> UINavigationController {
    let navigationController = UINavigationController()
    let tableViewController = TableViewController()

    navigationController.viewControllers = [tableViewController]

    return navigationController
}

func previewDetailViewController() -> UIViewController {
    let controller = DetailViewController()

    let image = Bundle
        .main
        .paths(forResourcesOfType: "jpg", inDirectory: nil)
        .first!

    let item = ImageItem(name: "Picture 1 of 1", path: image)

    controller.image = item

    return controller
}

PlaygroundPage.current.liveView = previewTableViewController()

