import UIKit
import PlaygroundSupport

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()

    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1

    func setupUILable(text: String, font: UIFont? = nil) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        if let font = font {
            label.font = font
        }
        return label
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        // MARK: Score Label

        scoreLabel = setupUILable(text: "Score: 0")
        scoreLabel.textAlignment = .right

        view.addSubview(scoreLabel)

        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])

        // MARK: Clues Label

        cluesLabel = setupUILable(text: "CLUES", font: UIFont.systemFont(ofSize: 24))
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)

        NSLayoutConstraint.activate([
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100)
        ])

        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)

        // MARK: Answers Label

        answersLabel = setupUILable(text: "ANSWERS", font: UIFont.systemFont(ofSize: 24))
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)

        NSLayoutConstraint.activate([
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
        ])

        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)

        // MARK: Textfield

        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)

        NSLayoutConstraint.activate([
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
        ])

        // MARK: Submit Button

        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        view.addSubview(submit)

        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44)
        ])

        // MARK: Clear Button

        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        view.addSubview(clear)

        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44)
        ])

        // MARK: Buttons View

        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)

        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.gray.cgColor

        NSLayoutConstraint.activate([
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])

        let width = 150, height = 80

        for row in 0..<4 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)

                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                buttonsView.addSubview(letterButton)

                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
    }

    override func viewDidLoad() {
        loadLevel()
    }

    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }

    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText

            answersLabel.text = splitAnswers?.joined(separator: "\n")
            currentAnswer.text = ""

            score += 1

            if letterButtons.filter({ !$0.isHidden }).isEmpty {
                let ac = UIAlertController(title: "Well done!",
                                           message: "Are you ready for the next level?",
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!",
                                           style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            let ac = UIAlertController(title: "Wrong Answer",
                                       message: "Try Again",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Done",
                                       style: .default, handler: { _ in
                self.clearTapped(self)
            }))
            score -= 1
            present(ac, animated: true)
        }
    }

    @objc func clearTapped(_ sender: Any) {
        currentAnswer.text = ""
        activatedButtons.forEach({ $0.isHidden = false })
        activatedButtons.removeAll()
    }

    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()

        if let path = Bundle.main.path(forResource: "level\(level)", ofType: "txt"),
           let levelContents = try? String(contentsOfFile: path) {
            var lines = levelContents.components(separatedBy: "\n")
            lines.shuffle()
            for (index, line) in lines.enumerated() {
                let parts = line.components(separatedBy: ": ")
                let answer = parts[0], clue = parts[1]

                clueString += "\(index + 1). \(clue)\n"

                let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                solutionString += "\(solutionWord.count) letters\n"
                solutions.append(solutionWord)

                let bits = answer.components(separatedBy: "|")
                letterBits += bits
            }
        }
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        letterBits.shuffle()
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }

    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        letterButtons.forEach({ $0.isHidden = false })

    }
}



let viewController = ViewController()
let displaySize = CGRect(x: 0, y: 0, width: 780, height: 800)
viewController.view.frame = displaySize
PlaygroundPage.current.liveView = viewController
