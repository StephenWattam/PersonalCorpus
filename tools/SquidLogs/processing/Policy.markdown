Squid policy
============

This document details the model of human interest that is applied to the squid logs.

It is based on my personal experience and notes, and may not be thoroughly generalisable.  Further study would be needed to assess the portability of the tool, though literature does exist regarding interest models for online content.

Literature
----------
Use of this tool for others must be governed by more general-purpose interest models, such as those based on screen resolution, position of elements, font, etc.  This generally falls upon search engine literature such as [this](http://www.sciencedirect.com/science/article/pii/S0169755298001081).

This section is a massive and notable TODO.


My policies
-----------
I have the distinct luxury of being able to rely on my own judgement for document importance.  This is especially relevant when considering that only a small portion of each web page is read, and only a few websites are truly visited often.

 * Imgur --- This website uses AJAX, and must have its pages scraped individually.  Additionally, each web page is heavily dependent on images, with little text.
 * Automated requests --- Those requests I don't action in the browser should be ignored.  This will require tuning of a large exception list, or a more seamless method of recording data (browser plugin?).
 

