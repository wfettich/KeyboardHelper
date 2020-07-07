# Synopsis:

This class scrolls the screen upwards when the virtual keyboard is shown so that it doesn't cover the actual text field. 

# Description:

There are many solutions to the annoying problem of having the virtual keyboard cover the currently focused UITextField. I've seen some use a good universal implementation like [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager) BUT they are not updated for use with or without Autolayout or other issues. 
This solution is fairly simple and adds a UIScrollView between your UIView and it's superview automatically. Sometimes simple is best. It works for views that use Autolayout constraints or just plain resizing masks. 

# How to use:

1. Create an instance of KeyboardHelper. 

<code>let keyboardHelper = KeyboardHelper()</code>

2. Add it to the superview of the UITextField or the view you wish to be scrolled up.  

<code>keyboardHelper.addTo(view: content)</code>

Optionally:  add your code in for the keyboard events

```
onKeyboardWillBeShown

onKeyboardWillBeResized

onKeyboardWillBeHidden
```

See the demo project KeyboardDemo for an example. 

![Appetize](urlhttps://appetize.io/embed/jjqk9katrtkb2t14nept2gu090?device=iphone6s&scale=75&orientation=portrait&osVersion=13.3)

# How it works:

When you attach it to a view it adds a UIScrollView as it's superview that uses the view as it's content. 

It also adds a gesture recognizer that resigns the current first responder when tapped. 


