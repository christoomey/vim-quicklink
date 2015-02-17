Vim Quicklink
=============

A Vim plugin for quickly looking up a topic and inserting the relevant link
into a markdown document.

![Overview](./overview.gif)

Usage
-----

Start by visually selecting the word or phrase you want to add a link around,
then press `<C-k>` to activate the plugin. A prompt will pop up asking for the
text to search for, defaulting to the highlighted text. Hit `<enter>` to run
the search. A results window will pop up with the following keymaps:

- `<tab>` - Jump to next search result
- `<S-tab>` - Jump to the previous result
- `o` - open the link for the result under the cursor in your browser
- `<enter>` - accept the result under the cursor
- `q` - quit out of the quicklink adventure

Additionally, the plugin lets you open a markdown reference (`[reference][]`) by
pressing `gx`. One may want to configure a diffrent mapping than this (`<cr>`
for e.g.) simply by mapping to the command `:MarkdownAwareGX`.

This functionnality uses `pi_netrw` (`:normal gx`) in order to open the link, so
it will open it using the program specified by the global variable
`g:netrw_browsex_viewer` (see `:h netrw-gx`). Also, `:normal gx` will behave
normally if on normal link.

Installation
------------

This plugin relies on a [webapi-vim][], a vimscript wrapper for interacting
with APIs. Assuming you're using Vundle, add the following line to your
`~/.vimrc` file:

``` vim
Bundle 'mattn/webapi-vim'
Bundle 'christoomey/vim-quicklink'
```

[webapi-vim]: https://github.com/mattn/webapi-vim
