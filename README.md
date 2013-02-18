V8SimpleBarGraphView
====================

by Shawn Veader (@veader) of
[V8 Logic](http://v8logic.com) /[V8 Labs, LLC](http://v8labs.com)

How to use V8SimpleBarGraphView
---------------------------------
Add the `V8SimpleBarGraphView` header and implementation files (.h and .m)
along with the protocol header file to your app source and include them in
your project.

Implement the necessary delegate and data source protocol methods.
Instantiate and add the graph view to your main view and wire up the delegate
and data source. That's it!

Delegate Protocol
----------------
    - (void)simpleBarGraphView:(V8SimpleBarGraphView *)graphView didHoverOnIndex:(NSUInteger)index;
    - (void)simpleBarGraphView:(V8SimpleBarGraphView *)graphView didTapOnIndex:(NSUInteger)index;
    - (UIColor *)colorForBarInSimpleGraphView:(V8SimpleBarGraphView *)graphView atIndex:(NSUInteger)index;

Data Source Protocol
-------------------
    - (NSUInteger)numberOfItemsInSimpleGraphView:(V8SimpleBarGraphView *)graphView;
    - (NSInteger)valueOfItemInSimpleGraphView:(V8SimpleBarGraphView *)graphView atIndex:(NSUInteger)index;


License
-------
See LICENSE file. TL;DR: I am publishing this under the
[BSD](http://en.wikipedia.org/wiki/BSD_licenses) license.

Thanks
------
Thanks for taking the time to check out the project. Let me know via the
GitHub issues feature if you find any bugs or have feature requests. Please
drop me a note and let me know if you use this in a project that hits the
AppStore.
