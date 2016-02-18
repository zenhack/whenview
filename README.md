WhenView is a tool for Visualizing the output of [when][1].

[when][1] is a simple command line calendar tool. I sometimes wish I had a way
to use it to see an actually *calendar* though. WhenView parses the output of
`when`, and transforms it into an html document, which can then be passed to a
browser for rendering.

By default, WhenView invokes `when` itself:

    $ whenview > out.html
    $ firefox out.html


If WhenViews's first and only argument is `--stdin`, the input will be
read from stdin:

    when --noheader | whenview > out.html
    firefox out.html

Note that the `--noheader` option is required.

Lynx can render from stdin:

    whenview | lynx -dump -stdin

...But unfortunately, lynx doesn't display the tables in a way that
looks much like a calendar. If you want to use a command line browser,
you can use Links:

    whenview > out.html
    links out.html

[1]: http://www.lightandmatter.com/when/when.html
