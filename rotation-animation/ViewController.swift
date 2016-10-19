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
        
        let widthX = meishiView.bounds.width * cos(CGFloat(M_PI) * 10 / 180)
        let widthY = meishiView.bounds.width * sin(CGFloat(M_PI) * 10 / 180)
        let heightX = meishiView.bounds.height * sin(CGFloat(M_PI) * 10 / 180)
        let heightY = meishiView.bounds.height * cos(CGFloat(M_PI) * 10 / 180)
        let p0 = (x: meishiView.frame.minX, y: meishiView.frame.minY + widthY)
        let p1 = (x: meishiView.frame.minX + widthX, y: meishiView.frame.minY)
        let p2 = (x: meishiView.frame.minX + meishiView.frame.width, y: meishiView.frame.minY + heightY)
        let p3 = (x: meishiView.frame.minX + heightX, y: meishiView.frame.minY + meishiView.frame.height)
        // --------------------------------------------------------
        
        // まずは傾きを4点から計算(4つの傾きの平均値)
        // 4つのdgreeを計算
        let maxX = p1.x > p2.x ? p1.x : p2.x
        let maxY = p2.y > p3.y ? p2.y : p3.y
        let minX = p0.x < p3.x ? p0.x : p3.x
        let minY = p1.y < p0.y ? p1.y : p0.y
        var degree1 = 0.0
        var degree2 = 0.0
        var degree3 = 0.0
        var degree4 = 0.0
        if minY == p1.y {
            let x = p1.x - p0.x
            let y = p0.y - p1.y
            let radian = Double(atan2(y, x))
            degree1 = radian.radianToDegrees
        } else {
            let x = p1.x - p0.x
            let y = p1.y - p0.y
            let tanθ = y / x
        }
        degree = 10 // 求めた！
        
        // 4点からframeを求める
        guard let degree = degree else { return }
        let θ = CGFloat(degree.degreeToRadians) // θ = π * d / 180
        let nameCardWidth1 = (p1.x - p0.x) / cos(θ)
        let nameCardWidth2 = (p2.x - p3.x) / cos(θ)
        let nameCardHeight1 = (p3.y - p0.y) / cos(θ)
        let nameCardHeight2 = (p2.y - p1.y) / cos(θ)
        let nameCardWidth = (nameCardWidth1 + nameCardWidth2) / 2
        let nameCardHeight = (nameCardHeight1 + nameCardHeight2) / 2
        // widthX、widthY、heightX、heigtYを求めてから
        let frameWidth = widthX + heightX
        let frameHeight = widthY + heightY
        let centerX = minX + (frameWidth / 2)
        let centerY = minY + (frameHeight / 2)
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

