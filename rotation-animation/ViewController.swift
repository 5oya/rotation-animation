//
//  ViewController.swift
//  rotation-animation
//
//  Created by Soya Takahashi on 2016/10/19.
//  Copyright © 2016年 NeXT, Inc. All rights reserved.
//

import UIKit

extension Double {
    var degreeToRadians: Double { return Double(self) * M_PI / 180 }
    var radianToDegrees: Double { return Double(self) * 180 / M_PI }
    
    // x: long side, y: short side
    static func tanθToDegrees(x x: CGFloat, y: CGFloat) -> Double {
        let radian = Double(atan2(y, x))
        let degrees = radian.radianToDegrees
        return degrees
    }
}

final class ViewController: UIViewController {
    private var degree: Double?
    lazy var videoPlayer: CALayer = {
        let videoPreviewLayer = CALayer()
        videoPreviewLayer.frame = self.view.frame
        return videoPreviewLayer
    }()
    lazy var meishiView: UIImageView = {
        let meishiView = UIImageView(frame: CGRect(x: self.view.bounds.width / 4, y: self.view.bounds.height / 4, width: 200, height: 120))
        meishiView.image = UIImage(named: "meisi.jpg")
        meishiView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * (-10) / 180)
        return meishiView
    }()
    lazy var rectanglesLayer: CAShapeLayer = {
        let rectanglesLayer = CAShapeLayer()
        return rectanglesLayer
    }()
    lazy var contentLayer: CAShapeLayer = {
        let contentLayer = CAShapeLayer()
        contentLayer.fillColor = UIColor.orangeColor().CGColor
        contentLayer.strokeColor = UIColor.blueColor().CGColor
        contentLayer.lineWidth = 1.0
        return contentLayer
    }()
    // CAShapeLayerかも？
    lazy var nameCardLayer: CALayer = {
        let nameCardLayer = CALayer()
//        nameCardLayer.contents = UIImage(named: "meisi.jpg")?.CGImage
        return nameCardLayer
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(meishiView)
        view.layer.addSublayer(videoPlayer)
        videoPlayer.addSublayer(rectanglesLayer)
        
        
        // --------------------　名刺の4点取得　----------------------
        
        let widthX0 = meishiView.bounds.width * cos(CGFloat(M_PI) * 10 / 180)
        let widthY0 = meishiView.bounds.width * sin(CGFloat(M_PI) * 10 / 180)
        let heightX0 = meishiView.bounds.height * sin(CGFloat(M_PI) * 10 / 180)
        let heightY0 = meishiView.bounds.height * cos(CGFloat(M_PI) * 10 / 180)
        let p0 = (x: meishiView.frame.minX + 10, y: meishiView.frame.minY + widthY0 + 10)
        let p1 = (x: meishiView.frame.minX + widthX0, y: meishiView.frame.minY)
        let p2 = (x: meishiView.frame.minX + meishiView.frame.width, y: meishiView.frame.minY + heightY0)
        let p3 = (x: meishiView.frame.minX + heightX0, y: meishiView.frame.minY + meishiView.frame.height)
        // --------------------------------------------------------
        
        // まずは傾きを4点から計算(4つの傾きの平均値)
        // 4つのdgreeを計算
        let maxX = p1.x > p2.x ? p1 : p2
        let maxY = p2.y > p3.y ? p2 : p3
        let minX = p0.x < p3.x ? p0 : p3
        let minY = p1.y < p0.y ? p1 : p0
        
        let x1 = minY.x - minX.x, y1 = minX.y - minY.y
        let degree1 = Double.tanθToDegrees(x: x1, y: y1)
        let x2 = maxX.y - minY.y, y2 = maxX.x - minY.x
        let degree2 = Double.tanθToDegrees(x: x2, y: y2)
        let x3 = maxX.x - maxY.x, y3 = maxY.y - maxX.y
        let degree3 = Double.tanθToDegrees(x: x3, y: y3)
        let x4 = maxY.y - minX.y, y4 = maxY.x - minX.x
        let degree4 = Double.tanθToDegrees(x: x4, y: y4)
        
        print("degree1: \(degree1)")
        print("degree2: \(degree2)")
        print("degree3: \(degree3)")
        print("degree4: \(degree4)")
        degree = (degree1 + degree2 + degree3 + degree4) / 4
        print("degree: \(degree)")
        
        // 4点からframeを求める
        guard let degree = degree else { return }
        let θ = CGFloat(degree.degreeToRadians)
        let nameCardWidth1 = (p1.x - p0.x) / cos(θ)
        let nameCardWidth2 = (p2.x - p3.x) / cos(θ)
        let nameCardHeight1 = (p3.y - p0.y) / cos(θ)
        let nameCardHeight2 = (p2.y - p1.y) / cos(θ)
        let nameCardWidth = (nameCardWidth1 + nameCardWidth2) / 2
        let nameCardHeight = (nameCardHeight1 + nameCardHeight2) / 2
        let widthX = nameCardWidth * cos(CGFloat(M_PI) * CGFloat(degree) / 180)
        let widthY = nameCardWidth * sin(CGFloat(M_PI) * CGFloat(degree) / 180)
        let heightX = nameCardHeight * sin(CGFloat(M_PI) * 10 / 180)
        let heightY = nameCardHeight * cos(CGFloat(M_PI) * 10 / 180)
        let frameWidth = widthX + heightX
        let frameHeight = widthY + heightY
        let centerX = minX.x + (frameWidth / 2)
        let centerY = minY.y + (frameHeight / 2)
        let centerPoint = CGPoint(x: centerX, y: centerY)
        nameCardLayer.contents = UIImage(named: "meisi.jpg")?.CGImage
        nameCardLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        nameCardLayer.bounds = CGRect(origin: .zero, size: CGSize(width: nameCardWidth, height: nameCardHeight))
        nameCardLayer.position = centerPoint
        nameCardLayer.transform = CATransform3DMakeRotation(-θ, 0.0, 0.0, 1.0)
        rectanglesLayer.addSublayer(nameCardLayer)

        
        // debug
        let fromPath = UIBezierPath()
        fromPath.moveToPoint(CGPoint(x: p0.x, y: p0.y))
        fromPath.addLineToPoint(CGPoint(x: p1.x, y: p1.y))
        fromPath.addLineToPoint(CGPoint(x: p2.x, y: p2.y))
        fromPath.addLineToPoint(CGPoint(x: p3.x, y: p3.y))
        fromPath.closePath()
        contentLayer.path = fromPath.CGPath
//        rectanglesLayer.addSublayer(contentLayer)
        //
    }
    
}

