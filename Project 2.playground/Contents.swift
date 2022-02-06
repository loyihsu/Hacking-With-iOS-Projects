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

    var questions: [String] = []

    let listOfCountries = [
        "United States", "France", "Germany", "Ireland", "Estonia", "Italy",
        "Monaco", "Nigeria", "Poland", "Russia", "Spain", "United Kingdom"
    ]

    let countryToFlag: [String: CountryFlags] = [
        "United States": .us, "France": .fr, "Germany": .ge, "Ireland": .ir, "Estonia": .es, "Italy": .it,
        "Monaco": .mo, "Nigeria": .ni, "Poland": .po, "Russia": .ru, "Spain": .sp, "United Kingdom": .uk
    ]

    let flagToCountry: [CountryFlags: String] = [
        .us: "United States", .fr: "France", .ge: "Germany", .ir: "Ireland", .es: "Estonia", .it: "Italy",
        .mo: "Monaco", .ni: "Nigeria", .po: "Poland", .ru: "Russia", .sp: "Spain", .uk: "United Kingdom"
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
        questions = listOfCountries
        askQuestion()
    }

    func askQuestion() {
        questions.shuffle()

        guard let question = questions.popLast() else {
            createAlert(title: "Your Final Score is \(yourScore)", message: "You've answered all the questions!")
            return
        }

        title = question + " (Score: \(yourScore))"

        var answerFlags = [countryToFlag[question]!]

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

        let nextQuestionAction = UIAlertAction(title: "Continue", style: .default, handler: { _ in
            self.askQuestion()
        })
        let thisAttempt = CountryFlags(rawValue: attempt)!
        if thisAttempt == translated {
            yourScore += 1
            createAlert(title: "Correcto!", message: "Your score is now \(yourScore).", action: nextQuestionAction)
        } else {
            yourScore -= 1
            let realCountry = flagToCountry[thisAttempt]!
            createAlert(title: "Uh-oh! Wrong answer!", message: "That's the flag of \(realCountry).\nYour score is now \(yourScore)", action: nextQuestionAction)
        }

    }

    func createAlert(title: String?, message: String?, action: UIAlertAction? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let action = action {
            alertController.addAction(action)
        } else {
            alertController.addAction(UIAlertAction(title: "Restart", style: .cancel, handler: { [self] _ in
                reset()
                alertController.dismiss(animated: true, completion: nil)
            }))
        }
        present(alertController, animated: true)
    }

    func reset() {
        yourScore = 0
        questions = listOfCountries
        askQuestion()
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = UINavigationController(rootViewController: GameViewController())