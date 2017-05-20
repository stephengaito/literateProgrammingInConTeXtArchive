# Design of Literate Programming in ConTeXt

This directory provides an initial collection of design documentation 
for the Literate Programming in ConTeXt project.

Most importantly we will be using the 
[ConTeXt](http://wiki.contextgarden.net) ([on 
wikipedia](https://en.wikipedia.org/wiki/ConTeXt)) document preparation 
toolset, which is a member of the TeX, and LaTeX family of document 
preparation systems.

One of the most important attributes of the ConTeXt system is that it is 
based upon the [LuaTeX](http://www.luatex.org/) typesetter which in turn 
embedds [Lua](https://www.lua.org/)

One of the key problems that this project is meant to solve is the 
typesetting of programming code. We will use the Lua based 
[lua-lxsh](https://github.com/daurnimator/lua-lxsh) (using 
[daurnimator's](https://github.com/daurnimator) more recent patches).

Another key problem is the ability to describe [graphical 
figures](http://wiki.contextgarden.net/Graphics) using 
[MetaFun](http://wiki.contextgarden.net/MetaFun).

There are a number of [ConTeXt-able text 
editors](http://wiki.contextgarden.net/Text_Editors), we will use 
[Textadept](https://foicica.com/textadept/) (a descendant of 
[Scite](http://wiki.contextgarden.net/Scite)).

Since Textadept does not have a native PDF/document viewer we will need 
to make extensive use of 
[SyncTeX](http://wiki.contextgarden.net/SyncTeX) to be able to jump 
between a document view and the original "source code".

Of particular importance is the ability to [convert the original ConTeXt 
document into HTML](http://tex.stackexchange.com/a/55945)

One way of using ConTeXt to *do* literate programming is [discussed 
here](http://tex.stackexchange.com/a/47010).

There exists a number of discussions on how to "do" ConTeXt for LaTeX 
users: [by Berend de Boer](http://www.berenddeboer.net/tex/),

[HTML, ConTeXt and collaborative 
editing](http://wiki.contextgarden.net/HTML_and_ConTeXt)

Finally here is [Kartik Agaram](http://akkartik.name/)'s reasonably 
radical analysis on [Literate 
Programming](http://akkartik.name/post/literate-programming).
