WhenView is a tool for Visualizing the output of [when][1].

[when][1] is a simple command line calendar tool. I sometimes wish I had a way
to use it to see an actually *calendar* though. WhenView parses the output of
`when`, and transforms it into an html document, which can then be passed to a
browser for rendering.

example:

    when --noheader | whenview | lynx -dump -stdin

This is still a work in progress; the above doesn't actually work yet.

[1]: http://www.lightandmatter.com/when/when.html
