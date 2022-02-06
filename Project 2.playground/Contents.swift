//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

enum CountryFlags: String {
    case us = "🇺🇸", fr = "🇫🇷", ge = "🇩🇪", ir = "🇮🇪", es = "🇪🇪", it = "🇮🇹",
         mo = "🇲🇨", ni = "🇳🇬", po = "🇵🇱", ru = "🇷🇺", sp = "🇪🇸", uk = "🇬🇧"
}

extension UIButton {
    func setTitle(_ flag: CountryFlags, for state: UIControl.State = .normal) {
        self.setTitle(flag.rawValue, for: state)
    }
}

class GameViewController : UIViewController {
    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()

    var yourScore = 0

    let sizeConstant: CGFloat = 120

    let listOfCountries = [
        "United States", "France", "Germany", "Ireland", "Estonia", "Italy",
        "Monaco", "Nigeria", "Poland", "Russia", "Spain", "United Kingdom"
    ]

    let countryToFlag: [String: CountryFlags] = [
        "United States": .us, "France": .fr, "Germany": .ge, "Ireland": .ir, "Estonia": .es, "Italy": .it,
        "Monaco": .mo, "Nigeria": .ni, "Poland": .po, "Russia": .ru, "Spain": .sp, "United Kingdom": .uk
    ]

    private func setupButton(_ button: UIButton, to view: UIView,
                             title: CountryFlags, offset: CGFloat = 0) {
        button.setTitle(title)
        view.addSubview(button)

        button.titleLabel?.font = UIFont.systemFont(ofSize: sizeConstant)

        button.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal,
                               toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal,
                               toItem: view, attribute: .centerY, multiplier: 1, constant: 0 + offset),
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal,
                               toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: sizeConstant),
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal,
                               toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: sizeConstant)
        ]

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate(constraints)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = UIView()
        view.backgroundColor = .systemBackground

        setupButton(button1, to: view, title: .us, offset: -sizeConstant)
        setupButton(button2, to: view, title: .uk)
        setupButton(button3, to: view, title: .fr, offset: sizeConstant)

        self.view = view

        self.navigationController?.navigationBar.prefersLargeTitles = true

        askQuestion()
    }

    func askQuestion() {
        let prevQuestion = (navigationController?.title ?? "").components(separatedBy: .whitespaces).first ?? ""
        var question = listOfCountries.randomElement()

        while question == prevQuestion {
            question = listOfCountries.randomElement()
        }

        title = question! + " (Score: \(yourScore))"

        var answerFlags = [countryToFlag[question!]!]

        var flag = countryToFlag[listOfCountries.randomElement()!]!

        while answerFlags.count < 3 {
            if !answerFlags.contains(flag) {
                answerFlags.append(flag)
            }
            flag = countryToFlag[listOfCountries.randomElement()!]!
        }

        answerFlags.shuffle()

        button1.setTitle(answerFlags[0])
        button2.setTitle(answerFlags[1])
        button3.setTitle(answerFlags[2])
    }

    @objc func buttonTapped(sender: UIButton!) {
        guard let navString = title else {
            fatalError("Why are you here?")
        }

        guard let attempt = sender.title(for: .normal) else {
            fatalError("You shouldn't be here either!")
        }

        let answer = navString.components(separatedBy: " (").first!
        let translated = countryToFlag[answer]!

        if CountryFlags(rawValue: attempt)! == translated {
            yourScore += 1
            createAlert(title: "Correcto!", message: "Your score is now \(yourScore).")
        } else {
            createAlert(title: "Uh-oh! Wrong answer!", message: "Your score is still \(yourScore)")
        }

    }

    func createAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            self.askQuestion()
        }))
        present(alertController, animated: true)
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = UINavigationController(rootViewController: GameViewController())
