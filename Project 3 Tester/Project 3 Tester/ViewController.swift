//
//  ViewController.swift
//  Project 3 Tester
//
//  Created by Yu-Sung Loyi Hsu on 2022/2/7.
//

import UIKit

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

        // This is intended for read app.
         let fm = FileManager.default
         let path = Bundle.main.resourcePath!
         let images = try! fm.contentsOfDirectory(atPath: path)
            .filter({ $0.contains("nssl") })
            .map({ "\(path)/\($0)" })

        pictures = images
            .sorted()
            .enumerated()
            .map({ (offset, path) -> ImageItem in
                return ImageItem(name: "Picture \(offset + 1) of \(images.count)", path: path)
            })

        // Register for reuse identifier for later use.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: myCustomCellId)

        title = "Storm Viewer"
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
}

class DetailViewController: UIViewController {
    var image: ImageItem!
    let imageView = UIImageView()

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemBackground

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

        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareTapped))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }


    @objc func shareTapped(_ caller: UIBarButtonItem!) {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }

        let controller = UIActivityViewController(activityItems: [image],
        applicationActivities: [])
        controller.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(controller, animated: true)
    }
}
