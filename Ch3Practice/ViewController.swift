import UIKit

class ViewController: UIViewController {
    // UILabel 생성
    private let Label = UILabel()
    private var currentExpression = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Label 설정
        Label.backgroundColor = .black
        Label.textColor = .white
        Label.text = "0" // Level 6에서 기본 값을 0으로 변경
        Label.textAlignment = .right
        Label.font = .boldSystemFont(ofSize: 60)
        Label.translatesAutoresizingMaskIntoConstraints = false // AutoLayout을 사용할거라서 false
        
        view.addSubview(Label)
        NSLayoutConstraint.activate([
            Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            Label.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            Label.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        let verticalStackView = makeVerticalStackView()
        view.addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.widthAnchor.constraint(equalToConstant: 350),
            verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView.topAnchor.constraint(equalTo: Label.bottomAnchor,constant: 60),
            verticalStackView.heightAnchor.constraint(equalToConstant: 80  * 4 + 10 * 3)
        ])
    }
    
    // Label AutoLayout 설정
    
    ///------------------------------------------------------
    // 버튼을 만드는 메서드 # Level 4,5 팁 반영
    private func makeButton(title: String, action: Selector, backgroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 30)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func makeHorizontalStackView(views: [UIView])-> UIStackView{
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.backgroundColor = .black
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 80),
            stackView.widthAnchor.constraint(equalToConstant: 350),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: Label.bottomAnchor, constant: 60)
        ])
        return stackView
    }
    
    private func makeVerticalStackView() -> UIStackView{
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .black
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 숫자 및 연산 버튼을 포함한 4개의 가로 스택 뷰 생성 및 추가
        let buttons = [
            ["1","2","3","+"],
            ["4","5","6","-"],
            ["7","8","9","*"],
            ["AC","0","=","/"]
        ]
        for row in buttons{
            var buttonViews: [UIButton] = []
            
            //각 버튼의 색상 설정
            
            for title in row{
                var buttonColor: UIColor
                if title == "+" || title == "-" || title == "/" || title == "*" || title == "AC" || title == "=" {
                    buttonColor = .orange
                } else{
                    buttonColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)
                }
                let button = makeButton(title: title, action: #selector(buttonTapped), backgroundColor: buttonColor)
                buttonViews.append(button)
            }
            let horizontalStackView = makeHorizontalStackView(views: buttonViews)
            stackView.addArrangedSubview(horizontalStackView)
        }
        return stackView
    }
    
    
    // 버튼 클릭 이벤트
    @objc private func buttonTapped(sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        //print("Button tapped: \(title)") Level 1~5까지 완료
        //버튼이 잘 눌려졌는지 확인 하기 위해서 추가 후 주석처리
        
        // Level 6~7
        if title == "AC" { // 초기화
            Label.text = "0"
        } else if title == "=" { // "="버튼 눌렀을 때 계산이 되게
            if let result = calculate(expression: currentExpression) {
                Label.text = "\(result)"
                currentExpression = "\(result)"
            } else {
                Label.text = "Error"
                currentExpression = ""
            }
        }else{
            if Label.text == "0" && title != "0" {
                currentExpression = title
            }else{
                currentExpression += title
            }
            Label.text = currentExpression
        }
        func calculate(expression: String) -> Int? { //메서드 참고
            let expression = NSExpression(format: expression)
            if let result = expression.expressionValue(with: nil, context: nil) as? Int {
                return result
            } else {
                return nil
            }
        }
    }
}
