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

class ViewController : UIViewController {
    var pictures = [ImageItem]()
    var collectionView: UICollectionView!

    let myCustomCellId = "myCustomCellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 180)
        layout.sectionInset = UIEdgeInsets(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10
        )


        collectionView = UICollectionView(
            frame: view.frame,
            collectionViewLayout: layout
        )

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])

        collectionView.dataSource = self
        collectionView.delegate = self

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
                self.collectionView.reloadData()
            }
        }

        // Register for reuse identifier for later use.
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: myCustomCellId)

        title = "Storm Viewer"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(recommend))
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

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: myCustomCellId,
            for: indexPath
        ) as? CollectionViewCell else {
            fatalError()
        }

        cell.textLabel.font = .systemFont(ofSize: 16, weight: .bold)

        let imageItem = pictures[indexPath.row]
        cell.textLabel.text = imageItem.name
        cell.imageView.image = UIImage(contentsOfFile: imageItem.path)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.image = pictures[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

class CollectionViewCell: UICollectionViewCell {
    var textLabel: UILabel!
    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        layer.cornerRadius = 7

        textLabel = UILabel()
        textLabel.font = UIFont(name: "Marker Felt", size: 16)
        textLabel.text = "Label"
        textLabel.textColor = .black
        textLabel.textAlignment = .center

        imageView = UIImageView()
        imageView.backgroundColor = .black

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textLabel)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leftAnchor
                .constraint(equalTo: leftAnchor, constant: 10),
            imageView.topAnchor
                .constraint(equalTo: topAnchor, constant: 10),
            imageView.widthAnchor
                .constraint(equalToConstant: 120),
            imageView.heightAnchor
                .constraint(equalToConstant: 120),
            textLabel.leftAnchor
                .constraint(equalTo: leftAnchor, constant: 10),
            textLabel.topAnchor
                .constraint(equalTo: imageView.bottomAnchor, constant: 4),
            textLabel.widthAnchor
                .constraint(equalToConstant: 120),
            textLabel.heightAnchor
                .constraint(equalToConstant: 40)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
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

func previewViewController() -> UINavigationController {
    let navigationController = UINavigationController()
    let viewController = ViewController()

    navigationController.viewControllers = [viewController]

    navigationController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 568)

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

PlaygroundPage.current.liveView = previewViewController()

