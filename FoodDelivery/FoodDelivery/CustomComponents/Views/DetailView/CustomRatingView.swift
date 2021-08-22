import UIKit

class CustomRatingView: UIView {
    let title   = CustomTitleLabel(textAlignment: .center, fontSize: 14)
    let rating  = CustomTitleLabel(textAlignment: .center, fontSize: 20)
    let stackView = UIStackView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
        
        title.text = "Hız"
        rating.text = "8,9"
        stackView.layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, rating: String, backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.title.text = title
        self.rating.text = rating
        self.backgroundColor = backgroundColor
    }
    
    
    private func configureStackView(){
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(rating)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemGreen
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 50),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
