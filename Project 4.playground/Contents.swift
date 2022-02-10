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
    }
}


PlaygroundPage.current.liveView = UINavigationController(
    rootViewController: ViewController()
)
