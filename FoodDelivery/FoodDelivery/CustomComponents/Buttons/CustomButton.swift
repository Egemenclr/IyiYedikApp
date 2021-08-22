import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title: String){
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    private func configure(){
        tintColor = .white
        backgroundColor = .systemPink
        layer.cornerRadius = 10
        titleLabel?.font = Fonts.helvetica
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(text: String, color: UIColor){
        setTitle(text, for: .normal)
        backgroundColor = color
    }
    
    
}
