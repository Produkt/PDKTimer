//
//  PDKTimer.swift
//  Produkt
//
//  Created by Daniel García García on 3/7/15.
//  Copyright © 2015 produkt. All rights reserved.
//

import Foundation

typealias TimedActionBlock = ()->()

class PDKTimer {
    var tolerance:NSTimeInterval = 0
    private let timeInterval:NSTimeInterval
    private var repeats:Bool
    private var action:()->()
    private var timer:dispatch_source_t
    private var privateSerialQueue:dispatch_queue_t
    private var targetDispatchQueue:dispatch_queue_t
    private var invalidated = false
    private let token:NSObject
    
    init(timeInterval:NSTimeInterval, repeats:Bool, dispatchQueue:dispatch_queue_t, action:TimedActionBlock){
        self.timeInterval = timeInterval
        self.repeats = repeats
        self.action = action
        token = NSObject()
        
        let privateQueueName = NSString(format: "com.produkt.pdktimer.%p", unsafeAddressOf(token))
        privateSerialQueue = dispatch_queue_create(privateQueueName.UTF8String, DISPATCH_QUEUE_SERIAL);
        targetDispatchQueue = dispatchQueue
        
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, privateSerialQueue);
        
        schedule()
    }
    
    convenience init(timeInterval:NSTimeInterval, repeats:Bool, action:TimedActionBlock){
        self.init(timeInterval:timeInterval, repeats:repeats, dispatchQueue:dispatch_get_main_queue(), action:action)
    }
    
    convenience init(timeInterval:NSTimeInterval, action:TimedActionBlock){
        self.init(timeInterval:timeInterval, repeats:false, action:action)
    }
    
    deinit{
        self.invalidate()
    }
    
    class func every(interval: NSTimeInterval, dispatchQueue:dispatch_queue_t, _ block: TimedActionBlock) -> PDKTimer{
        let timer = PDKTimer(timeInterval: interval, repeats: true, dispatchQueue: dispatchQueue, action: block)
        return timer
    }
    
    class func every(interval: NSTimeInterval, _ block: TimedActionBlock) -> PDKTimer{
        let timer = PDKTimer(timeInterval: interval, repeats: true, action: block)
        return timer
    }
    
    class func after(interval: NSTimeInterval, dispatchQueue:dispatch_queue_t, _ block: TimedActionBlock) -> PDKTimer{
        let timer = PDKTimer(timeInterval: interval, repeats: false, dispatchQueue: dispatchQueue, action: block)
        return timer
    }
    
    class func after(interval: NSTimeInterval, _ block: TimedActionBlock) -> PDKTimer{
        let timer = PDKTimer(timeInterval: interval, repeats: false, action: block)
        return timer
    }
    
    func fire(){
        timerFired()
        if repeats{
            schedule()
        }
    }
    
    func schedule(){
        resetTimer()
        dispatch_source_set_event_handler(timer){
            dispatch_async(self.targetDispatchQueue) {
                self.timerFired()
            }
        }
        dispatch_resume(timer);
    }
    
    func invalidate(){
        let invalidableTimer = timer;
        dispatch_async(privateSerialQueue, {
            dispatch_source_cancel(invalidableTimer)
        });
    }
    
    private func timerFired(){
        if invalidated { return }
        
        action()
        
        if !repeats {
            invalidate()
        }
    }
    
    private func resetTimer(){
        let intervalInNanoseconds = Int64(timeInterval * Double(NSEC_PER_SEC))
        let toleranceInNanoseconds = Int64(tolerance * Double(NSEC_PER_SEC))
        
        dispatch_source_set_timer(timer,
            dispatch_time(DISPATCH_TIME_NOW, intervalInNanoseconds),
            UInt64(intervalInNanoseconds),
            UInt64(toleranceInNanoseconds)
        );
    }
}

extension Double {
    public var millisecond:  NSTimeInterval { return self / 100 }
    public var milliseconds:  NSTimeInterval { return self / 100 }
    public var second:  NSTimeInterval { return self }
    public var seconds: NSTimeInterval { return self }
    public var minute:  NSTimeInterval { return self * 60 }
    public var minutes: NSTimeInterval { return self * 60 }
    public var hour:    NSTimeInterval { return self * 3600 }
    public var hours:   NSTimeInterval { return self * 3600 }
}