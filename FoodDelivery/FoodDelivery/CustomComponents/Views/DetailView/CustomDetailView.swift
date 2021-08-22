import UIKit

class CustomDetailView: UIView {
    
    let imageView = UIImageView()
    let title = CustomTitleLabel(textAlignment: .left, fontSize: 14)
    let stackView = UIStackView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
        imageView.tintColor = .lightGray
        isUserInteractionEnabled = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: String, title: String) {
        self.init()
        
        self.imageView.image = UIImage(systemName: image)
        self.title.text = title
    }
    
    func setUI(image: String, title: String){
        self.imageView.image = UIImage(systemName: image)
        self.title.text = title
    }
    
    private func configureStackView(){
        self.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(title)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
}
