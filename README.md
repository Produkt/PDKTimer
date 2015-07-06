# PDKTimer
A simple swift GCD based Timer

## Why?

Why do we need a new timer if we already have `NSTimer`?

`NSTimer` is an Objective-C class that needs a `@selector` to call. As in swift, we don't have selectors, whe have to pass a `String` with the name of the function we want to be called. Something like :

```
let timer = NSTimer(timeInterval: 0.5, target: self, selector: "myfunction", userInfo: nil, repeats: false)
```

Yikes!

The problem with that is that `myfunction` string will be evaluated in run-time. That means we would make a typo in the name of the function and the compiler won't be able to tell us that code won't execute.


Wouldn't it be nice if whe could pass a closure to the timer?

##How to use it

Using `PDKTimer` is really easy. Simply call 

```
let timer = PDKTimer(timeInterval: 5.0, repeats: true){
	// do something
}
```

and that closure will be executed each 5 seconds

###Note (Scheduling):
`PDKTimer` instances don't do [auto schedule](#autoscheduling). You have to manually call `schedule` in order to start.

```
let timer = PDKTimer(timeInterval: 5.0, repeats: true){
	// do something
}
timer.schedule()
```


##GCD powered

`PDKTimer` is implemented using [GCD](https://developer.apple.com/library/ios/documentation/Performance/Reference/GCD_libdispatch_Ref/) APIs. It isn't a Swift wrapper that uses `NSTimer` on the inside. This allows not only executing the timer in a background queue, but dispatching the timed closure on a specific `dispatch queue`. 
Simply create your timer using : 

```
let dispatchQueue = dispatch_queue_create("com.produkt.pdktimer.test", DISPATCH_QUEUE_SERIAL)
PDKTimer(timeInterval: 0.5, repeats: false, dispatchQueue: dispatchQueue){
	// do something
}
``` 

and your closure will be executed on your custom queue


##Syntax sugar

I really liked [SwiftyTimer](https://github.com/radex/SwiftyTimer) API from [radex](https://github.com/radex), that is a Swift wrapper for `NSTimer`
So I adopted the API that he suggests. 

You can create repeating and non-repeating timers with `PDKTimer.every` and `PDKTimer.after` short-hand initializers

```
PDKTimer.every(5.seconds){
	// executes every 5 seconds
}

PDKTimer.after(5.seconds){
    // waits 5 seconds and then executes once
}
```

An extension of Double is also defined so you can define time intervals with [Ruby-on-Rails](http://rubyonrails.org/)-like helpers

```
500.milliseconds
1.second
2.5.seconds
5.seconds
10.minutes
1.hour
```


###Note (Scheduling): <a name="autoscheduling"></a>
`PDKTimer` short-hand initializers **do** auto schedule. So you **don't need** to manually call schedule

```
PDKTimer.every(5.seconds){

}
// no scheduling needed
```


##Author

Daniel García

[https://github.com/fillito](https://github.com/fillito)
[https://github.com/Produkt](https://github.com/Produkt)


##Thanks

Thanks to [Javi Soto](https://github.com/JaviSoto) for writing [MSWeakTimer](https://github.com/mindsnacks/MSWeakTimer). It helped me a lot understanding som GCD APIs to implement a timer

Thanks to [Radek Pietruszewski](https://github.com/radex) for designing [SwiftyTimer](https://github.com/radex/SwiftyTimer) API, that I basically ripped off 
