//
//  SpringIntegrator.swift
//  Optik
//
//  Created by Htin Linn on 7/24/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import Foundation

/// RK4 integrator. Source: http://gafferongames.com/game-physics/integration-basics/
internal struct SpringIntegrator<T: Interpolatable> {
    
    // MARK: - Properties
    
    /// Friction constant.
    var friction: CGFloat = 28
    
    /// Spring constant.
    var spring: CGFloat = 250
    
    // MARK: - Instance functions
    
    /**
     Returns accleration based on given position and velocity.
     
     - parameter position: Position.
     - parameter velocity: Velocity.
     
     - returns: Acceleration.
     */
    func acceleration(position: T, velocity: T) -> T {
        return -spring * position - friction * velocity
    }
    
    /**
     Integrates given position and velocity based on the time elapsed and 
     returns changes in position and velocity over the given period.
     
     - parameter position: Position.
     - parameter velocity: Velocity.
     - parameter dt:       Time elapsed.
     
     - returns: Changes in position and velocity over the given period.
     */
    func integrate(position: T, velocity: T, dt: CFTimeInterval) -> (dpdt: T, dvdt: T) {
        let halfDt = CGFloat(dt) * 0.5
        
        let dp1 = velocity
        let dv1 = acceleration(position, velocity: velocity)
        
        let dp2 = velocity + halfDt * dv1
        let dv2 = acceleration(position + halfDt * dp1, velocity: dp2)
        
        let dp3 = velocity + halfDt * dv2
        let dv3 = acceleration(position + halfDt * dp2, velocity: dp3)
        
        let dp4 = velocity + CGFloat(dt) * dv3
        let dv4 = acceleration(position + CGFloat(dt) * dp3, velocity: dp4)
        
        let dpdt = 1 / 6 * (dp1 + 2 * (dp2 + dp3) + dp4)
        let dvdt = 1 / 6 * (dv1 + 2 * (dv2 + dv3) + dv4)
        
        return (dpdt, dvdt)
    }
    
}
