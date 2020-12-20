//
//  PulsingTimer.swift
//  DinerTimer
//
//  Created by Alexander Ha on 12/20/20.
//

import UIKit

class PulsingTimer: UIView {
    //MARK: - UIComponents
    
    public lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "SFProText-Medium", size: 56)
        label.setDimensions(height: 222, width: 222)
        label.backgroundColor = #colorLiteral(red: 0.9881569743, green: 0.9569149613, blue: 0.8940123916, alpha: 1)
        label.layer.cornerRadius = 222 / 2
        label.layer.masksToBounds = true
        return label
    }()
    
    public lazy var finishedTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "SFProText-Ultralight", size: 18)
        return label
    }()
    
    private lazy var bellIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bell")
        iv.tintColor = .black
        return iv
    }()
    
    public lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = #colorLiteral(red: 0.8157042265, green: 0.203938216, blue: 0.3097853363, alpha: 1).withAlphaComponent(0.8).cgColor
        layer.lineWidth = 35
        layer.lineCap = .round
        layer.fillColor = UIColor.clear.cgColor
        layer.zPosition = 1
        return layer
    }()
    
    private lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = #colorLiteral(red: 0.9450542331, green: 0.7765093446, blue: 0.4783833623, alpha: 1).cgColor
        layer.lineWidth = 35
        layer.lineCap = .round
        layer.fillColor = UIColor.clear.cgColor
        layer.zPosition = 0
        return layer
    }()
    
    public lazy var pulsingLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.clear.cgColor
        layer.lineWidth = 15
        layer.lineCap = .round
        layer.fillColor = UIColor.clear.cgColor
        layer.zPosition = -1
        return layer
    }()
    
    public lazy var progressAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1.0
        animation.speed = 1.0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        return animation
    }()
    
    public lazy var pulsingAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1
        animation.toValue = 1.2
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        return animation
    }()
    
    //MARK: - Properties
    
    public var timer = Timer()
    public var timeLeft: TimeInterval = 0
    public var cookTime: Double! = 0
    public var savedTime: Double!
    
    public var date: Date?
    public let calendar = Calendar.current
    
    public var calculator = CookTimeCalculator()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    
    public func startTime() {
        finishedTimeLabel.text = calculateEndTime()
        layer.addSublayer(progressLayer)
        progressAnimation.duration = timeLeft
        progressLayer.speed = 1.0
        progressLayer.add(progressAnimation, forKey: "stroke")
        pulsingLayer.speed = 1.0
        pulsingLayer.add(pulsingAnimation, forKey: "pulsing")
        date = Date().addingTimeInterval(timeLeft)
    }
    
    public func resumeAnimation() {
        let pausedTime = progressLayer.timeOffset
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        let timeSincePause = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressLayer.beginTime = timeSincePause
        pulsingLayer.speed = 1.0
        pulsingLayer.add(pulsingAnimation, forKey: "pulsing")
    }
    
    public func pauseAnimation() {
        let pausedTime: CFTimeInterval = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0.0
        progressLayer.timeOffset = pausedTime
        pulsingLayer.speed = 0.0
    }
    
    private func configureUI() {
        let startAngle = 1.5 * CGFloat.pi
        let center = self.center
        let pulsingPath = UIBezierPath(arcCenter: center, radius: 125, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        let circularPath = UIBezierPath(arcCenter: center, radius: 118, startAngle: startAngle, endAngle: startAngle + 2 * CGFloat.pi , clockwise: true)
        
        progressLayer.path = circularPath.cgPath
        trackLayer.path = circularPath.cgPath
        layer.addSublayer(trackLayer)
        
        pulsingLayer.path = pulsingPath.cgPath
        pulsingLayer.position = center
        pulsingLayer.frame = bounds
        layer.addSublayer(pulsingLayer)
        
        
//        cookTime = calculator.calculateCookTime(for: PROTEIN.type, method: PROTEIN.method, doneness: PROTEIN.doneness)
//        timeLeft = cookTime
        timeLeft = 0.0
        timerLabel.text = timeLeft.time
        addSubview(timerLabel)
        timerLabel.centerX(inView: self)
        timerLabel.centerY(inView: self)
        
        finishedTimeLabel.text = "hh:mm"
        timerLabel.addSubview(finishedTimeLabel)
        finishedTimeLabel.centerX(inView: timerLabel, constant: 4)
        finishedTimeLabel.centerY(inView: timerLabel, constant: 50)
        
        timerLabel.addSubview(bellIcon)
        bellIcon.setDimensions(height: 15, width: 15)
        bellIcon.anchor(top: finishedTimeLabel.topAnchor,
                        trailing: finishedTimeLabel.leadingAnchor,
                        paddingTop: 4,
                        paddingTrailing: 2)
    }
    
    private func calculateEndTime() -> String {
        let date = Date()
        var hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let calculatedMinutes = minute + Int(cookTime / 60)
        
        if calculatedMinutes > 60 {
            hour += 1
            if calculatedMinutes % 60 > 10 {
                finishedTimeLabel.text = "\(hour):\(calculatedMinutes % 60)"
            } else if calculatedMinutes % 60 < 10 {
                finishedTimeLabel.text = "\(hour):0\(calculatedMinutes % 60)"
            }
        } else if calculatedMinutes == 60 {
            finishedTimeLabel.text = "\(hour):00"
        } else if calculatedMinutes < 10 {
            finishedTimeLabel.text = "\(hour):0\(calculatedMinutes)"
        } else {
            finishedTimeLabel.text = "\(hour):\(calculatedMinutes)"
        }
        guard let finishedTimeLabelText = finishedTimeLabel.text else { return ""}
        return finishedTimeLabelText
    }
    
}
