# AWK-Script language support in Atom
[![apm][2]][1]

Adds syntax highlighting to awk scripts in Atom.



## Preview
![Grammar Preview][preview_grammar]



## Installation

```sh
apm install language-awk
```

or find it in the Packages tab under settings.



## Something Special
Ever getting bored by searching your code for "tracing lines"  ([print debugging][wiki_tracing]) and finally discovering you missed one (naturally after commit)? Me too!

Therefore I put a small matching rule in this grammar. Every line starting with:

```
printf "[DEBUG]..."
# or
printf "[DBG]..."
# or
print "[DEBUG]"
# and of course
print "[DBG]"
```

Is scoped as `meta.debug` and with a little help from Atoms style features something(\*) like:

```
printf "[DBG]=(%s):=[%s]\n", "strvar", strvar
```

Will be shown as:  
![Preview Debug][preview_debug]

Eye-catching, isn't it? And finally...  
![Preview Output][preview_output]

\*) *Looks cumbersome but you can get it fast & simple using snippets.*


### Customize / Disable
The debug highlighting is controlled by a view style rules. If you want to set your own debug-marker style just add the following to your `styles.less` and change the rules to your flavor:

```css
atom-text-editor::shadow {
  .meta.debug {
    background-color: fade(@background-color-warning, 20%) !important;
    border: 1px solid fade(@background-color-warning, 50%);
    border-radius: 0.8em;
    padding-top: 0.1em;
    padding-right: 0.7em;
    padding-bottom: 0.1em;
    padding-left: 0.7em;
  }
}
```

You don't like specials? Well, extend your `styles.less` with this:

```css
atom-text-editor::shadow {
  .meta.debug {
    background-color: initial !important;
    border: initial;
    border-radius: initial;
    padding: initial;
  }
}
```



[1]: https://atom.io/packages/language-awk
[2]: https://img.shields.io/apm/l/icon-fonts.svg?style=flat
[preview_grammar]: https://cloud.githubusercontent.com/assets/15639707/11132101/69340aea-898e-11e5-98d6-9f7f84e9bd0a.png
[wiki_tracing]: https://en.wikipedia.org/wiki/Debugging#Techniques (Wikipedia)
[preview_debug]: https://cloud.githubusercontent.com/assets/15639707/11132094/5f99095e-898e-11e5-80b5-31ba9a0ae612.png
[preview_output]: https://cloud.githubusercontent.com/assets/15639707/11132190/df8f5500-898e-11e5-9ac5-cc6862d3513b.png
