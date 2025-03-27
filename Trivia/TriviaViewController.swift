
import UIKit

extension String {
    var htmlUnescape: String {
        let data = Data(self.utf8)
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        let unescapedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil).string
        return unescapedString ?? self
    }
}

struct TriviaQuestion {
    let type: String
    let question: String
    let answers: [String]
    let correctAnswer: Int
}

struct TriviaAPIResponse: Codable {
    let response_code: Int
    let results: [TriviaAPIQuestion]
}

struct TriviaAPIQuestion: Codable {
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}

class TriviaViewController: UIViewController {
    
    @IBOutlet weak var questionNum: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    // Add these functions after your existing properties
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private func setupLoadingIndicator() {
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
    }
    
    private func showLoading() {
        loadingIndicator.startAnimating()
        questionNum.text = ""
        answerLabel.text = ""
        answerButton1.setTitle("", for: .normal)
        answerButton2.setTitle("", for: .normal)
        answerButton3.setTitle("", for: .normal)
        answerButton4.setTitle("", for: .normal)
        [questionNum, answerLabel, answerButton1, answerButton2, answerButton3, answerButton4].forEach { $0?.isHidden = true }
    }
    
    private func hideLoading() {
        loadingIndicator.stopAnimating()
        [questionNum, answerLabel, answerButton1, answerButton2].forEach { $0?.isHidden = false }
    }
    //
    
    
    var questions: [TriviaQuestion] = []
    var selectedQuestions: [TriviaQuestion] = []
    var currentQuestionIndex = 0
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
        fetchTriviaQuestions()
    }

  
    func fetchTriviaQuestions() {
        showLoading()
        guard let url = URL(string: "https://opentdb.com/api.php?amount=5&difficulty=easy") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            do {
                let apiResponse = try JSONDecoder().decode(TriviaAPIResponse.self, from: data)
                self.questions = apiResponse.results.map { apiQuestion in
                    let allAnswers = apiQuestion.incorrect_answers + [apiQuestion.correct_answer]
                    let shuffledAnswers = allAnswers.shuffled()
                    let correctIndex = shuffledAnswers.firstIndex(of: apiQuestion.correct_answer) ?? 0
                    
                    return TriviaQuestion(type: apiQuestion.type, question: apiQuestion.question.htmlUnescape, answers: shuffledAnswers.map { $0.htmlUnescape }, correctAnswer: correctIndex)
                }
                DispatchQueue.main.async {
                    self.currentQuestionIndex = 0
                    self.selectedQuestions = Array(self.questions.shuffled().prefix(5))
                    self.displayQuestion()
                    self.hideLoading()
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }

        task.resume()
    }

    func displayQuestion() {
        let currentQuestion = selectedQuestions[currentQuestionIndex]
        answerLabel.text = currentQuestion.question
        questionNum.text = "Question \(currentQuestionIndex + 1) of 5"

        if currentQuestion.type == "boolean" {
            answerButton1.setTitle(currentQuestion.answers[0], for: .normal)
            answerButton2.setTitle(currentQuestion.answers[1], for: .normal)
            answerButton3.isHidden = true
            answerButton4.isHidden = true
        } else {
            answerButton1.setTitle(currentQuestion.answers[0], for: .normal)
            answerButton2.setTitle(currentQuestion.answers[1], for: .normal)
            answerButton3.setTitle(currentQuestion.answers[2], for: .normal)
            answerButton4.setTitle(currentQuestion.answers[3], for: .normal)
            answerButton3.isHidden = false
            answerButton4.isHidden = false
        }
    }

    @IBAction func didTapAnsButton1(_ sender: UIButton) {
        handleAnswerSelection(for: sender, answerIndex: 0)
    }

    @IBAction func didTapAnsButton2(_ sender: UIButton) {
        handleAnswerSelection(for: sender, answerIndex: 1)
    }

    @IBAction func didTapAnsButton3(_ sender: UIButton) {
        handleAnswerSelection(for: sender, answerIndex: 2)
    }

    @IBAction func didTapAnsButton4(_ sender: UIButton) {
        handleAnswerSelection(for: sender, answerIndex: 3)
    }

    func handleAnswerSelection(for sender: UIButton, answerIndex: Int) {
        let currentQuestion = selectedQuestions[currentQuestionIndex]
        if answerIndex == currentQuestion.correctAnswer {
            score += 1
        }
        currentQuestionIndex += 1
        if currentQuestionIndex < selectedQuestions.count {
            displayQuestion()
        } else {
            showFinalScore()
        }
    }

    func showFinalScore() {
        let alert = UIAlertController(title: "Quiz Finished", message: "Your score is \(score)/5", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.restartQuiz()
        }))
        present(alert, animated: true, completion: nil)
    }

    func restartQuiz() {
        
        
        
        
        //selectedQuestions = Array(questions.shuffled().prefix(5))
        //currentQuestionIndex = 0
        score = 0
        fetchTriviaQuestions()
        //displayQuestion()
    }
    
    
}
