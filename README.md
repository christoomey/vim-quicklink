Vim Quicklock
=============

A Vim plugin for quickly looking up a topic and inserting the relevant link
into a markdown document.

Usage
-----

Start by visually selecting the word or phrase you want to add a link around,
then press `<C-k>` to activate the plugin. A prompt will pop up asking for the
text to search for, defaulting to the hihglighted text. Hit `<enter>` to run
the search. A results window will pop up with the following keymaps:

- `<tab>` - Jump to next search result
- `<S-tab>` - Jump to the previous result
- `o` - open the link for the result under the cursor in your browser
- `<enter>` - accept the result under the cursor
- `q` - quit out of the quicklink adventure

Installation
------------

Add the following line to your `~/.vimrc` file:

``` vim
Bundle 'christoomey/vim-tmux-navigator'
```
