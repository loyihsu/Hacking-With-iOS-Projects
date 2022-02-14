//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class TableViewCell: UITableViewCell {
    var subtitleLabel: UILabel!

    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont(name: "HelveticaNeue", size: 12)

        contentView.addSubview(subtitleLabel)

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
    }
}


class TableViewController : UITableViewController {
    var petitions: [String] = ["A", "B", "C"]

    let myCustomCellId = "My Cell"

    override func viewDidLoad() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: myCustomCellId)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCustomCellId, for: indexPath) as! TableViewCell

        cell.textLabel?.text = "Title goes here"
        cell.subtitleLabel.text = "Subtitle goes here"
        return cell
    }
}

let tabBarController = UITabBarController()
tabBarController.viewControllers = [TableViewController()]
PlaygroundPage.current.liveView = tabBarController
