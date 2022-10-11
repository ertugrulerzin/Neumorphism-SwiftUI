//
//  CustomShapeView.swift
//  CustomSwitchStyle
//
//  Created by Pratik on 06/10/22.
//

import SwiftUI

struct PolyShape: Shape {
    var count: Int
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        draw(on: &path, size: rect.size)
        return path
    }
    
    func draw(on path: inout Path, size: CGSize) {
        
//        for i in 0..<count {
//
//            if i == 0 {
//                let currentPoint: CGPoint = point(angle: angle(index: CGFloat(i)), size: size)
//                path.move(to: currentPoint)
//            }
//
//            let nextPoint: CGPoint = point(angle: angle(index: CGFloat(i) + 1.0), size: size)
//            path.addLine(to: nextPoint)
//
//        }
//
//        path.closeSubpath()
        
        let aCornerRadius: CGFloat = cornerRadius
        
        for i in 0..<count {
            
            let prevPoint: CGPoint = point(angle: angle(index: CGFloat(i) - 1.0), size: size)
            let currentPoint: CGPoint = point(angle: angle(index: CGFloat(i)), size: size)
            let nextPoint: CGPoint = point(angle: angle(index: CGFloat(i) + 1.0), size: size)
            
            let cornerCircle: RounedCornerCircle = rounedCornerCircle(leading: prevPoint,
                                                                      center: currentPoint,
                                                                      trailing: nextPoint,
                                                                      cornerRadius: aCornerRadius)
            
            let startAngle = angle(index: CGFloat(i) - 0.5)
            let startAngleInRadians: Angle = .radians(Double(startAngle) * .pi * 2.0)
            let endAngle = angle(index: CGFloat(i) + 0.5)
            let endAngleInRadians: Angle = .radians(Double(endAngle) * .pi * 2.0)
            
            path.addArc(center: cornerCircle.center,
                        radius: aCornerRadius,
                        startAngle: startAngleInRadians,
                        endAngle: endAngleInRadians,
                        clockwise: false)
            
        }
        
        path.closeSubpath()
        
        
    }
    
    func radius(size: CGSize) -> CGFloat {
        min(size.width, size.height) / 2.0
    }
    
    func angle(index: CGFloat) -> CGFloat {
        index / CGFloat(count) - 0.25
    }
    
    func point(angle: CGFloat, size: CGSize) -> CGPoint {
        let x: CGFloat = size.width / 2.0 + cos(angle * .pi * 2.0) * radius(size: size)
        let y: CGFloat = size.height / 2.0 + sin(angle * .pi * 2.0) * radius(size: size)
        return CGPoint(x: x, y: y)
    }
    
    
    struct RounedCornerCircle {
        let center: CGPoint
        let leading: CGPoint
        let trailing: CGPoint
    }
    
    func rounedCornerCircle(leading: CGPoint,
                            center: CGPoint,
                            trailing: CGPoint,
                            cornerRadius: CGFloat) -> RounedCornerCircle {
        rounedCornerCircle(center, leading, trailing, cornerRadius)
    }
    
    private func rounedCornerCircle(_ p: CGPoint,
                                    _ p1: CGPoint,
                                    _ p2: CGPoint,
                                    _ r: CGFloat) -> RounedCornerCircle {
        
        var r: CGFloat = r
        
        //Vector 1
        let dx1: CGFloat = p.x - p1.x
        let dy1: CGFloat = p.y - p1.y
        
        //Vector 2
        let dx2: CGFloat = p.x - p2.x
        let dy2: CGFloat = p.y - p2.y
        
        //Angle between vector 1 and vector 2 divided by 2
        let angle: CGFloat = (atan2(dy1, dx1) - atan2(dy2, dx2)) / 2
        
        // The length of segment between angular point and the
        // points of intersection with the circle of a given radius
        let _tan: CGFloat = abs(tan(angle))
        var segment: CGFloat = r / _tan
        
        //Check the segment
        let length1: CGFloat = sqrt(pow(dx1, 2) + pow(dy1, 2))
        let length2: CGFloat = sqrt(pow(dx2, 2) + pow(dy2, 2))
        
        let _length: CGFloat = min(length1, length2)
        
        if segment > _length {
            segment = _length;
            r = _length * _tan;
        }
        
        // Points of intersection are calculated by the proportion between
        // the coordinates of the vector, length of vector and the length of the segment.
        let p1Cross: CGPoint = proportion(p, segment, length1, dx1, dy1)
        let p2Cross: CGPoint = proportion(p, segment, length2, dx2, dy2)
        
        // Calculation of the coordinates of the circle
        // center by the addition of angular vectors.
        let dx: CGFloat = p.x * 2 - p1Cross.x - p2Cross.x
        let dy: CGFloat = p.y * 2 - p1Cross.y - p2Cross.y
        
        let L: CGFloat = sqrt(pow(dx, 2) + pow(dy, 2))
        let d: CGFloat = sqrt(pow(segment, 2) + pow(r, 2))
        
        let circlePoint: CGPoint = proportion(p, d, L, dx, dy)
        
        return RounedCornerCircle(center: circlePoint, leading: p1Cross, trailing: p2Cross)
        
    }
    
    private func proportion(_ point: CGPoint,
                            _ segment: CGFloat,
                            _ length: CGFloat,
                            _ dx: CGFloat,
                            _ dy: CGFloat) -> CGPoint {
        let factor: CGFloat = segment / length
        return CGPoint(x: point.x - dx * factor,
                       y: point.y - dy * factor)
    }
}
