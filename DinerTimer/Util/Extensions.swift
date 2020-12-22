//
//  Extensions.swift
//  DinerTimer
//
//  Created by Alexander Ha on 12/11/20.
//

import UIKit

extension UIView {
    
    //MARK: - Anchors
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeading: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingTrailing: CGFloat = 0,
                height: CGFloat? = nil,
                width: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    func centerX(inView view: UIView, leadingAnchor: NSLayoutXAxisAnchor? = nil, paddingLeading: CGFloat = 0, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
        
        if let leading = leadingAnchor {
            anchor(leading: leading, paddingLeading: paddingLeading)
        }
    }
    
    func centerY(inView view: UIView, leadingAnchor: NSLayoutXAxisAnchor? = nil, paddingLeading: CGFloat = 0, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let leading = leadingAnchor {
            anchor(leading: leading, paddingLeading: paddingLeading)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func NSLayoutActivate(_ objects:[NSLayoutConstraint]) {
        objects.forEach({$0.isActive = true})
    }
    
    func NSLayoutDeactivate(_ objects:[NSLayoutConstraint]) {
        objects.forEach({$0.isActive = false})
    }
    
    //MARK: - Animations
    
    func fade(out view: UIView, _ optionalView: UIView?, completion: (() -> Void)?) {
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: .zero, options: .curveEaseInOut) {
            view.transform = CGAffineTransform(translationX: -350, y: 0)
            view.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.8) {
                view.transform = .identity
            }
        }
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 1.0, initialSpringVelocity: .zero, options: .curveEaseInOut) {
            if let optionalView = optionalView {
                optionalView.transform = CGAffineTransform(translationX: -350, y: 0)
                optionalView.alpha = 0
                
                if completion != nil {
                    completion!()
                } else {
                    optionalView.transform = .identity
                }
            }
        } completion: { _ in
            UIView.animate(withDuration: 0.8) {
                guard let optionalView = optionalView else { return }
                optionalView.transform = .identity
            }
        }
    }
    
    
}

//MARK: - UI Configurations

extension UIViewController {
    
    func configureNavBar(withTitle title: String, prefersLargeTitle: Bool) {
        //Creating a constant with our customized settings
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black,
                                               .font: UIFont(name: "SFProText-Regular", size: 32)!]
        appearance.backgroundColor = #colorLiteral(red: 0.9335944057, green: 0.6621651053, blue: 0.7384092212, alpha: 1)
        
        //Sets all of the navigation bar's attributes to our constant 'appearance'
        navigationItem.title = title
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitle
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : #colorLiteral(red: 0.4614635429, green: 0.2202478027, blue: 0.2029526682, alpha: 1)]
        
        //overrides status bar to be white (battery | wifi symbol | time)
        navigationController?.navigationBar.overrideUserInterfaceStyle = .light
    }
    
    func drawCheckerBoard(imageView: UIImageView) {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: view.frame.width, height: view.frame.height))
        let img = renderer.image { context in
            context.cgContext.setFillColor(#colorLiteral(red: 0.9940704703, green: 0.9595301747, blue: 0.968749702, alpha: 1).cgColor)
            for row in 0 ..< 36 {
                for col in 0 ..< 36 {
                    if (row + col) % 2 == 0 {
                        context.cgContext.fill(CGRect(x: col * 24, y: row * 24, width: 24, height: 24))
                    }
                }
            }
        }
        imageView.image = img
    }
}

//MARK: - Time Formatting

extension TimeInterval {
    
    public var time: String {
        return String(format: "%02d:%02d", Int(self/60), Int(ceil(truncatingRemainder(dividingBy: 60))))
    }
    
}

