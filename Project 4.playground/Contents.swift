//: A UIKit based Playground for presenting user interface
  
import UIKit
import WebKit
import PlaygroundSupport

class ViewController : UIViewController, WKNavigationDelegate {
    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Open",
            style: .plain,
            target: self,
            action: #selector(openTapped)
        )
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    @objc func openTapped() {
        let alertController = UIAlertController(
            title: "Open page...",
            message: nil,
            preferredStyle: .actionSheet)
        alertController.addAction(
            UIAlertAction(title: "apple.com", style: .default, handler: openPage)
        )
        alertController.addAction(
            UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage)
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
    }
}


PlaygroundPage.current.liveView = UINavigationController(
    rootViewController: ViewController()
)
