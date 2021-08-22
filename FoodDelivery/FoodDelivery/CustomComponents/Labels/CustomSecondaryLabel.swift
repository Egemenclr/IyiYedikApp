import UIKit

class CustomSecondaryLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat){
        self.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    convenience init(fontSize: CGFloat, textAlignment: NSTextAlignment){
        self.init(frame: .zero)
        self.font       = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        self.textAlignment = textAlignment
    }
    
    private func configure(){
        
        minimumScaleFactor = 0.9
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}


extension CustomSecondaryLabel{
    func textStyle(font: UIFont){
        self.font = font
    }
}
