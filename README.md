WhenView is a tool for Visualizing the output of [when][1].

[when][1] is a simple command line calendar tool. I sometimes wish I had a way
to use it to see an actually *calendar* though. WhenView parses the output of
`when`, and transforms it into an html document, which can then be passed to a
browser for rendering.

Example:

    when --noheader | whenview > out.html
    firefox out.html

Lynx can render from stdin:

    when --noheader | whenview | lynx -dump -stdin

...But unfortunately, lynx doesn't display the tables in a way that
looks much like a calendar. If you want to use a command line browser,
you can use Links:

    when --noheader | whenview > out.html
    links out.html

Note that the `--noheader` option is required.

[1]: http://www.lightandmatter.com/when/when.html
