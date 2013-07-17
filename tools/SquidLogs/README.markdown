Squid Log Processor
===================
This tools is designed to parse SQUID proxy logs and output a list of URLs for which I, likely, read part of the page.

This is based on:

 * Username
 * MIME type
 * URL Patterns
 * Return code
 * Time between reloads

After this tool has been run, items of interest must be extracted from the resultant data:

 * Conversion to text
 * Removal of AJAX, non-human-readable content
 * Removal of unread portions

This is a job for the second tool, which contains an interest model based on my personal browsing usage.