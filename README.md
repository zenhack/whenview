WhenView is a tool for Visualizing the output of [when][1].

[when][1] is a simple command line calendar tool. I sometimes wish I had a way
to use it to see an actually *calendar* though. WhenView parses the output of
`when`, and transforms it into an html document, which can then be passed to a
browser for rendering.

# Running

If invoked with no arguments, WhenView invokes `when` itself, and then
passes the resulting html to the browser.

If WhenViews's first and only argument is `--stdin`, the input will be
read from standard input:

    when --noheader | whenview --stdin

Note that the `--noheader` option is required.

By default, WhenView uses xdg-open to select the browser. This can be
overridden with the `-b`/`--browser` option:

    whenview -b links

A file containing the html will be passed as the first argument to the
browser.

If you want to send the html to standard output, you can do something
like:

    whenview -b cat

Any additional arguments are passed through to when itself.

# Styling

The output of `whenview` includes a style rule to draw borders around
the days in the calendar; this is considered essential to the usability
of the program. If a stylesheet `~/.when/view.css` exists, it will also
be applied to the document. An example `view.css` is available at the
root of the source tree; it contains some improvements.

[1]: http://www.lightandmatter.com/when/when.html
