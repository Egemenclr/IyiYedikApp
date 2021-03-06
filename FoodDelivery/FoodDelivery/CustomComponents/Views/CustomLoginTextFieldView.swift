import UIKit

class CustomLoginTextFieldView: UIView {

    let headerText = CustomTitleLabel(textAlignment: .left, fontSize: 14)
    let textField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()

    }
    
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        configureHeaderText()
        configureTextfield()
    }

    func set(headerText: String, placeHolder: String){
        self.headerText.text = headerText
        self.textField.placeholder = placeHolder
    }

    private func configureHeaderText(){
        addSubview(headerText)

        headerText.translatesAutoresizingMaskIntoConstraints = false

        headerText.textColor = .secondaryLabel

        headerText.font = Fonts.helvetica
        NSLayoutConstraint.activate([
            headerText.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            headerText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            headerText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            headerText.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func configureTextfield(){
        addSubview(textField)

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: headerText.bottomAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: headerText.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: headerText.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setTextFieldHeight(height: CGFloat){
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: headerText.bottomAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: headerText.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: headerText.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: height)
        ])
    }

}
