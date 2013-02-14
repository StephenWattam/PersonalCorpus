Data Sources
============
Sources of linguistic data vary wildly, and a variety of methods will be needed to record salient parameters of even the most prominent ones.

Intent
------
The aim of this document is to identify the sources of language to which I am exposed on a daily basis, and from that list to formulate methods which may be used to record various properties thereof.  

See also [Variables](Variables) for a list of interesting properties---not all of these will be recorded for every source due to the inherent difficulties of sampling such voluminous data.

Data Sources
------------

### Speech
I expect this to comprise the bulk of all data in the corpus (as do Biber and others).  The most obvious solution to gathering this data is to record things using a voice recorder, and a microphone placed to pick up what one's ears normally would.

The main issue with recording is the set of [ethical issues](../Ethics) raised.  Indeed, depending on context and consent it may be illegal to record even for personal use---it is almost certainly illegal to record for use by third parties (such as a transcription service).  It's reasonable to assume that, if I am to gather speech data, it must never be passed to anyone else.

The benefits of recording speech data as audio run to:

 * Word counts are more accurate;
 * It's possible to ascertain the number of speakers;
 * Much informal, short, ephemeral speech will be caught that would otherwise not be noted down (i.e. in a notebook);
 * The actual text may be recorded (if legal).

Of course, if this is not ethically justifiable, some compromise may be reached whereby audio is processed automatically.  This would ensure that it need not be passed to a third party, as speech recognition software could be used to ascertain:

 * The actual text used (though it seems recording quality would be insufficient to recreate this using current speech recognition);
 * The times when people are speaking (and from this, an estimate of the word count that is more than simple hand-waving);
 * Ephemeral speech and single-word utterances.

If it is impossible, ethically and legally, to record audio, then one must fall back on a notebook or smartphone app.  This should contain a selection of covariates that will include things such as the number of speakers, duration of the interaction, etc.

Note: [SoX](http://sox.sourceforge.net/Docs/Features) contains Voice Activity Detection routines.  [Snack](http://www.speech.kth.se/snack/) may also come in handy.

### Documents

#### Printed 
Printed documents are significantly less sensitive (usually) than speech, and have fewer ethical concerns.  Where a document is confidential, its absence, and a description of its external variables, may be noted down for later proxies to be substituted.

Where a document is available and non-confidential, it may be photocopied, or a picture may be taken with a smartphone.  Modern OCR software should be able to digitise things from these sources.

One benefit of taking records of printed or physical items is that they may easily be looked up in order to fill out their external information later.  This removes some of the time-critical aspects of data recording.


#### Digital 
These may simply be saved to a folder for the day.  Depending on the resolution necessary, it might be useful to note down when a document was encountered.

Web documents may be retrieved automatically using a transparent proxy.  Email can be retrieved by the date upon which it was read, and saved accordingly.

One particularly interesting problem surrounds saving data in a central location when using multiple systems of different types.  It may be useful to write a small (encrypted) web upload script to store things on a centrally-accessible server.

### Ephemera

#### Digital 
Most use of computers is quite loggable.  A keylogger can effectively capture many of the smaller text entry events, and this data would prove useful alone.

Logs are easily kept of smaller uses of text, such as:

 * Console session output, which can be piped straight into a log;
 * IRC/chat logs, which are already stored by date and time.

#### Other 
Items such as billboards, posters, adverts and magazines may require photographing, as they are likely to be encountered only for a very short period of time (and contain little text).  EXIF data may be used to identify the date and time of encounters, and photographs will provide much of the information which would otherwise be noted in a notebook (regarding likely age, format, etc. of the resource).

Published items such as flyers and newspapers may be noted down or taken for later reference.




Recording Methods
-----------------

### Notebook
A trusty reporters' notebook seems like it might be the most versatile option for recording external variables.  A simple grid could be easily ruled on each page, and a pen slipped in the binding to fill out each column.

This method has a number of advantages.  It is low-cost, easy to add to/retire/maintain, and can record very free-form data extremely quickly (writing is probably the fastest data entry method behind mumbling notes to myself).

Use of the notebook would likely elicit very little suspicion, and change the linguistic environment little.  The only thing likely to arouse less suspicion would be a smartphone app, because kids these days are always on facebook.

The main disadvantage of using this method is that one might have to write many entries for lots of very small texts, which would become irksome if many variables on each were recorded.  Some of the data sources would be easy to retroactively comment, and their presence need only be recorded initially with most fields left blank.

### Smartphone App
A smartphone app could be produced to record external variables.  This could prove much faster and less noticable than using a notebook, but is likely to be much less flexible.  The relative disruption of using a phone or notebook must be weighed in preliminary studies.

Unlike a notebook, a smartphone is fairly expensive, and is likely to encounter technical failures, especially when used in more extreme environments (such as the Lakes).  It seems likely that this will be a 'best case' tool, and a notebook must also be carried.

The development time required to produce a smartphone application capable of quickly recording each of the external variables should also not be ignored, especially since I have no background in mobile development.


### Audio Recording
See the 'Speech' data source above for a discussion on the ethics of this method.  Many voice recorders exist that have a sensitivity and recording time sufficient to record all sounds heard during a day, and this could be synced to a computer every night with relative ease.

Microphones are available that are both very covert and sensitive.

### Web Proxy
Squid and iptables can be configured to transparently proxy, retaining all data in comprehensive logs.  This could be easily filtered by time and MIME type when retrieved, but would require similar cleaning procedures to those applied on web corpora.

### Logs
Logs are already stored for IRC, and all keypresses could be logged, though this would entail a fair amount of overlap for documents created by the researcher.

### Scanner
A scanner could be used to digitise documents, though this is only useful for those documents to which one has prolonged access (and yet cannot keep).  The document scanner in the infolab emails the scanned in document, making it easy to sort by date.

### Camera
A camera may be best suited to recording things such as posters, flyers or billboards.  The smartphone on one's camera is likely to cause fewest funny looks, and will tag things with GPS, time, and date information using EXIF tags.  Android phones may be set to automatically upload their photos to a storage server such as Picasa too, which would allow for easy (categorised) retrieval by date/time.

### Offsite Storage
A simple page may be posted on a web server to upload and store electronic documents that are encountered on alien systems.  This application would be able to record the time/date of upload and sort files into appropriate folders for later review.
