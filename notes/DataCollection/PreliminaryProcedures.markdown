Preliminary Data Gathering Procedures
-------------------------------------
This document forms a specification of data gathering procedures to be used for preliminary trials of corpus recording.

It is based on the following documents:

 * [The Sampling Policy](SamplingPolicy)
 * [A specification of important variables](Variables)
 * [Sources and methods of data collection](DataSources)

See [the report on preliminary tests](PreliminaryReport) for the outcomes and progress.

<span style="color: red;">This method has been superseded by: [this document](PreliminaryProcedureAmendments), which includes amendments from the preliminary report.</span>

Aims
----
The intent of the preliminary study is to assess:

 1. Methods for sampling text from various sources without great disruption
    - The possibility of processing audio records in accordance with ethical ideals
    - Technical measures required to sample digital documents
    - Devices necessary to digitise other sources of text
 2. The best ways to record metadata about texts unobtrusively
 3. The utility of captured data w.r.t. annotation and comparison to other corpora
 4. Further work needed to create monitoring tools and methods

When sampling, the absolute minimum needed to describe a textual interaction should be:

 * Some indication of text length, be it via title, genre or explicit notes.
 * Some indication of the role the text plays, sufficient to fetch a proxy from other sources

In the ideal case, data gathered will include the full text itself (in whatever format).  This pilot is concerned with how close it's practical to get to that ideal.

Variables
---------

### Direct Recording
The selection of variables that can be directly recorded is necessarily limited---they must be sufficiently general to hold meaning for many text types, and yet informative enough to satisfy their inclusion in a very limited set of variables.  

I estimate that I am limited to below 5 pieces of metadata per text---any more than this would prove too arduous on collection efforts, and would interrupt the natural consumption of language.  

Even with this modest aim, some variables may have to be filled in after the event, using data from cameras, notebooks, audio recordings or digital information.  This process will be necessary for many items in order to build up a body of data that is comparable to the rich information found in many corpora.  It also seems likely that many taxonomic distinctions made in the field will not apply directly to corpora simply due to the mismatch in proportions of content.  These will also have to be resolved at a later date, since any a priori solution would discard information from the field data.

 * *ID*---Some method of identifying any attached content data (time, image description, etc)
 * *Genre/Type*---freeform, to be coded later.  This will simply be the purpose/classification of the text at a very informal, human level.  Examples will include things such as 'book, factual' or 'flyer'.  This may also include what is strictly data on the *medium*, since recording the two together may prove easier in the field.
 * *Age*---The time from the date of publication (possibly estimated) to the current date.  Accuracy of this is expected to inversely correlate with value.
 * *Author*---The name, or some other ID, for the author
 * *Title*---If the whole record cannot be captured, the title may be useful.
 * *Setting*---Environment in which the text was encountered.  Easy enough to fill in asynchronously, but hard to infer at a later date.  Examples include 'home', 'work', etc.
 * *Notes*---Any other information that may be useful when reconstructing data.



### Later Annotation
Variables below are necessary and useful for analysis, but are largely identifiable from inspection of the smaller set gathered in the field, memory, and judgement of text/other metadata (such as the author's name).

 * *Authorship*---Was the text created by a corporation, individual or group?
 * *Size of intended readership*---The number of recipients intended to experience the text.
 * *Text status*---Is the text 'new', 'revised', etc?
 * *Language*---Expected to generally be English.
 * *Author sex*---The sex of the author.  Expected to be inferred from names
 * *Topic*---The topic of the text
 * *Factuality*---How factual is the text (expected to be)?
 * *Familiarity with intended readership*---How formal is the text?

Data Sources
------------

 * *Audio*---to be noted using paper notebooks (using the parameters above), and to be recorded using a handheld voice recorder
 * *Digital documents*---to be saved to a versioned repository (committed every night).  
 * *Web history listings*---actual content will be retrieved later.
 * *IRC Logs*---These can be logged using a custom client plugin.
 * *Keypresses*---A keylogger will be installed on each machine that is often used, and this will record timestamped text entry.
 * *Phone usage*---This will be noted in the metadata notebooks.  Calls may be recorded depending on technical limitations.

Recording Procedures
--------------------

### Digital Documents
A git repository will be created to hold digital information.  Its commit log will testify to the date of recording, in addition to metadata stored in notebooks and files themselves.

Because of the 'constant stream' nature of some of the data sources, they will be set to download continuously to a file within the repository.  Committing it will create a snapshot at that point that can later be recalled.  A commit will be run at least once a day.

This repository is to hold:

 * Audio recordings
 * keylogger output
 * IRC logs
 * web history

The repository may also be checked out remotely in many locations, with a directory within it for each machine regularly used.  It will be necessary, before leaving a machine, to sync the repositories.  Many years of software dev have already trained me to do this, so the procedure should be fairly sustainable.

### Audio
Audio recordings will begin when I first become conscious.  A microphone will be attached to the recorder, and will be carried clipped to some external clothing in order to detect all 'ambient' audio including radio, TV, etc.

Files will be downloaded from the recorder nightly, saved in the same data repository as other digital content.

In order to sync up times with notebook metadata, the time of first recording will be noted.

### Physical Documents
Physical documents, where 'keepable', will be filed in expanding folders at home (nightly), with one folder kept per day.

With luck the number of physical documents recorded will be low enough that they are identifiable on an intra-day basis from notebook metadata.

### Metadata (paper notebooks)
Paper notebooks will be pre-ruled with tables for each of the variables from the Direct Recording section above.  

These will be dated at the beginning of a day, and will record texts as encountered, with sufficient notes to recall them at a later date.

### Off-computer Digital Documents
A small page will be made to upload documents.  These will be timestamped and retained online (aside from the git repository) for later merging.

Along with the file itself, metadata as listed in Direct Recording may be recorded.

### Photographs of Physical Documents
These will be automatically uploaded to Picasa using the android auto-upload feature.  They will be time, date and location stamped in EXIF data, and may be retrieved in-order using said information.

The taking of a photograph shall be noted in the metadata notebooks.

Operationalisation Procedures
------------------------------
Processing of collected data will proceed in a few phases:

### Consolidation of Data
Items of data will need to be gathered from various sources:

 * The digital documents git repository
 * Picasa, for photos (which will need sorting by EXIF date)
 * On-server uploaded data
 * Metadata from paper notebooks

This will be collated into a database, with each record holding a link to the document in its native form.

### Annotation of Data
The document metadata will be augmented with parameters derived from inspection of the existing record.  This will yield a full set of metadata for comparison to other corpora, and may be the final stage if real text contents are not required (or legal to acquire).

### Digitisation/Transcription
Internal text features will be extracted from documents.  For the majority of digital documents, this will require only a quick cleaning script.

For audio, attempts will be made to identify text/spoken regions/participants without divulging data to a third party.  This may prove impossible.

Photos will have to be manually transcribed.

Web history listings will be downloaded and cleaned into plaintext form.  This can be particularly aggressive, since it is unlikely that the whole page was read.

Where data is missing from the original text, this should be recorded, and a proxy source of data sought.


Analysis
--------
Of particular interest from the preliminary study is:

 1. What qualitative problems were encountered during data acquisition?
 2. How much missing/proxy data occurs?  Why?
 3. Do the findings support suspicions in the literature (and thus continuation of the study)?
 4. Can any processes be improved?  Were any modified during the trial?

See [the report on preliminary tests](PreliminaryReport) for the outcomes and progress.
