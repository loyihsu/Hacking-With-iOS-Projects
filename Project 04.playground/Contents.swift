//: A UIKit based Playground for presenting user interface
  
import UIKit
import WebKit
import PlaygroundSupport

fileprivate var websites = ["apple.com", "hackingwithswift.com"]

class TableViewController: UITableViewController {
    let myCustomCellId = "myCustomCellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: myCustomCellId)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCustomCellId, for: indexPath)

        cell.textLabel?.text = websites[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ViewController()
        viewController.website = "https://" + websites[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}

class ViewController : UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!

    var website = "https://www.hackingwithswift.com"

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: website)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Open",
            style: .plain,
            target: self,
            action: #selector(openTapped)
        )

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh,
                                      target: webView,
                                      action: #selector(webView.reload))

        let goBack = UIBarButtonItem(barButtonSystemItem: .undo ,target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(barButtonSystemItem: .redo, target: webView, action: #selector(webView.goForward))

        toolbarItems = [progressButton, spacer, goBack, goForward, refresh]
        navigationController?.isToolbarHidden = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites where host.contains(website) {
                decisionHandler(.allow)
                print(website)
                return
            }
        }

        decisionHandler(.cancel)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    @objc func openTapped() {
        let alertController = UIAlertController(
            title: "Open page...",
            message: nil,
            preferredStyle: .actionSheet)

        for website in websites {
            alertController.addAction(
                UIAlertAction(title: website, style: .default, handler: openPage)
            )
        }

        alertController.addAction(
            UIAlertAction(title: "www.google.com", style: .default, handler: openPage)
        )

        alertController.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )

        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }

    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
        if !websites.contains(action.title!) {
            let alert = UIAlertController(title: "This URL is blocked!",
                                          message: nil,
                                          preferredStyle: .alert)

            alert.addAction(
                UIAlertAction(title: "Close",
                              style: .cancel)
            )

            present(alert, animated: true, completion: nil)
        }
    }
}


PlaygroundPage.current.liveView = UINavigationController(
    rootViewController: TableViewController()
)
