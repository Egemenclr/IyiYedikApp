import UIKit

class CustomBodyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment){
        self.init(frame: .zero)
        self.textAlignment = textAlignment
    }
    
    private func configure(){
        
        minimumScaleFactor = 0.75
        textColor = .secondaryLabel
        lineBreakMode = .byWordWrapping
        adjustsFontSizeToFitWidth  = true
        adjustsFontForContentSizeCategory = true
        font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }

}

