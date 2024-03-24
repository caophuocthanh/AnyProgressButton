

# AnyProgressButton


<center><img src="https://github.com/caophuocthanh/AnyProgressButton/blob/main/Screenshoot/screenshot.png?raw=true" width="60%"></center>

Custom UIControl to show progress and you can drag to change the value with valueChanged

## How to use

```swift

    lazy var button: AnyProgessButton = {
       let view  = AnyProgessButton()
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(button)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        
        var titleContraints: [NSLayoutConstraint] = []
        titleContraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-50-[button]-50-|",
            options: [],
            metrics: nil,
            views: ["button" : self.button])
        titleContraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-150-[button(30)]",
            options: [],
            metrics: nil,
            views: ["button" : self.button])
        
        self.view.addConstraints(titleContraints)
        
        self.button.backgroundColor = .clear
        self.button.textColor       = .white
        self.button.maskedColor     = .black
        self.button.cornerRadius    = 16
        self.button.progress        = 0.56
        self.button.borderWidth     = 1
        self.button.borderColor     = .black
        self.button.font            = UIFont.boldSystemFont(ofSize: 16)
        self.button.addTarget(self, action: #selector(changed), for: .valueChanged)
    }
    
    @objc func changed() {
        print("process:", self.button.progress)
    }

```

## Contact
- Email: caophuocthanh@gmail.com
- Site: https://onebuffer.com
- Linkedin: https://www.linkedin.com/in/caophuocthanh/

