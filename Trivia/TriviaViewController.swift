
import UIKit

struct TriviaQuestion {
    let question: String
    let answers: [String]
    let correctAnswer: Int
}

class TriviaViewController: UIViewController {
    
    @IBOutlet weak var questionNum: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    var questions: [TriviaQuestion] = [
        TriviaQuestion(question: "What does HTML stand for?", answers: ["Hyperlink Markup Language", "Hyper Text Machine Language", "Hyper Text Markup Language", "Hungry Tigers Make Lasagna" ], correctAnswer: 2),
        TriviaQuestion(question: "What is the name of the most famous version control system used by programmers?", answers: ["Git", "Fit", "Bit", "FitBit"], correctAnswer:0),
        TriviaQuestion(question: "In JavaScript, what keyword is used to declare a variable?", answers:["let", "var", "const", "All of the above"], correctAnswer: 3),
        TriviaQuestion(question: "What do programmers use to write and edit code?", answers: ["Notepad", "Integrated Development Environment (IDE)", "Text Editor", "A Magic Typewriter"], correctAnswer: 1),
        TriviaQuestion(question: "What does CSS stand for?", answers: ["Cascading Style Sheets", "Coding Super Skills", "Computer Style System", "Cats Stealing Sandwiches"], correctAnswer: 0),
        TriviaQuestion(question: "Which animal is the mascot for the Python programming language?", answers: ["Python snake", "Anaconda", "Cobra", "A squirrel wearing glasses"], correctAnswer: 0),
        TriviaQuestion(question: "What is the main purpose of a loop in programming?", answers: ["To repeat a block of code", "To confuse beginners", "To make programs longer", "To hypnotize your computer"], correctAnswer: 0),
        TriviaQuestion(question: "What’s the name of the first computer programmer?", answers: ["Alan Turing", "Ada Lovelace", "Grace Hopper", "Tony Stark"], correctAnswer: 1),
        TriviaQuestion(question: "What does “bug” refer to in programming?", answers: ["An insect in your room", "An error in the code", "A feature that doesn’t work", "A mischievous gremlin living in your computer"], correctAnswer: 1)
    ]
    
    
    

    var selectedQuestions: [TriviaQuestion] = []
    var currentQuestionIndex = 0
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedQuestions = Array(questions.shuffled().prefix(3))
        displayQuestion()
    }

    func displayQuestion() {
        let currentQuestion = selectedQuestions[currentQuestionIndex]
        answerLabel.text = currentQuestion.question
        questionNum.text = "Question \(currentQuestionIndex + 1) of 3"
        answerButton1.setTitle(currentQuestion.answers[0], for: .normal)
        answerButton2.setTitle(currentQuestion.answers[1], for: .normal)
        answerButton3.setTitle(currentQuestion.answers[2], for: .normal)
        answerButton4.setTitle(currentQuestion.answers[3], for: .normal)
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
        let alert = UIAlertController(title: "Quiz Finished", message: "Your score is \(score)/3", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.restartQuiz()
        }))
        present(alert, animated: true, completion: nil)
    }

    func restartQuiz() {
        selectedQuestions = Array(questions.shuffled().prefix(3))
        currentQuestionIndex = 0
        score = 0
        displayQuestion()
    }
}
