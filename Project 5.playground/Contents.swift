//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class TableViewController : UITableViewController {
    var allWords = [String](), usedWords = [String]()

    let cellIdentifier = "Word"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(promptForAnswer))


        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                           target: self,
                                                           action: #selector(startGame))


        if let file = Bundle.main.path(forResource: "start", ofType: "txt"),
           let content = try? String(contentsOfFile: file) {
            allWords = content.components(separatedBy: .newlines)
            assert(allWords.count != 0)
        } else if allWords.isEmpty {
            allWords = ["silkworm"]
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        startGame()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        guard tempWord != word else { return false }
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }

    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    func isReal(word: String) -> Bool {
        guard word.count >= 3 else { return false }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word, range: range, startingAt: 0, wrap: false, language: "en"
        )
        return misspelledRange.location == NSNotFound
    }

    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()

        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(lowerAnswer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                } else {
                    showErrorMessage(title: "Word not recognised",
                                     message: "You cannot just make them up, you know!")
                }
            } else {
                showErrorMessage(title: "Word used already",
                                 message: "Be more original!")
            }
        } else {
            guard let title = title?.lowercased() else { return }
            showErrorMessage(title: "Word not possible",
                             message: "You cannot spell that word from \(title)")
        }
     }

    func showErrorMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        present(alertController, animated: true)
    }

    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll()
        tableView.reloadData()
    }

    @objc func promptForAnswer() {
        let alertController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        alertController.addTextField()

        // strong reference cycle: object A owns object B
        // and object B owns a closure that referenced object A
        // closure capture everything they use == Object B owns Object A

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] action in
            guard let answer = alertController?.textFields?[0].text else { return }
            self?.submit(answer)
        }

        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = UINavigationController(rootViewController: TableViewController())
