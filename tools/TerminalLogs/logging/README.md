Terminal Logger
===============
The intent of this tool is to log, using the `script' tool, everything typed into terminals.

The 'term_lifelog' application simply reads and applies system-wide settings to script, using a YAML file in /etc/.  It provides the following functionality:

 * Automatic creation of log files named for the day they are created

That's about it for now :-)

Use
---
To use the output of the command, whilst still escaping the output:

    eval "$(./term_lifelog.rb)"

or any other shell.

I recommend adding this to your shell rc file.
