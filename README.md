# HTML::Pipeline Cite Gem [![Build Status](https://travis-ci.org/lifted-studios/html-pipeline-cite.png?branch=master)](https://travis-ci.org/lifted-studios/html-pipeline-cite)

An [HTML::Pipeline](https://github.com/jch/html-pipeline) filter for WikiMedia-style [Cite references](http://www.mediawiki.org/wiki/Extension:Cite/Cite.php).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'html-pipeline-cite'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install html-pipeline-cite
```

## Usage

This gem offers an [HTML::Pipeline](https://github.com/jch/html-pipeline) filter that collects references in the text and inserts a table of footnotes where instructed.

Example:

```html
<ref>This is a footnote</ref>
```

Becomes:

```html
<sup class="reference" id="wiki-cite_ref-1">[<a href="#wiki-cite_note-1">1</a>]</sup>
```

It will show up as a bracketed, superscripted and anchored number at that location in the text.  Then when 
`<references/>` is placed in the text, an ordered list of the references and their text will be placed at that
location.  The example above would generate a list that looks like this:

```html
<ol>
  <li id="wiki-cite_note-1"><b><a href="#wiki-cite_ref-1">^</a></b> This is a footnote.</li>
</ol>
```

<!--
## Troubleshooting
-->

## Development

To see what has changed in recent versions of the `html-pipeline-cite` gem, see the [CHANGELOG](CHANGELOG.md).

## Core Team Members

* [Lee Dohm](https://github.com/lee-dohm/)

<!--
## Resources
-->
<!-- ### Other questions

Feel free to chat with the Lifted Wiki core team (and many other users) on IRC in the  [#project](irc://irc.freenode.net/project) channel on Freenode, or via email on the [Project mailing list]().
 -->

## Copyright

Copyright © 2013 Lee Dohm, Lifted Studios. See [LICENSE](LICENSE.md) for details.

Project is a member of the [OSS Manifesto](http://ossmanifesto.com/).
