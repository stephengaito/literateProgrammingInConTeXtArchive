-- A Lua template file

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/conclusion.tex after line: 50

-- Copyright 2019 PerceptiSys Ltd (Stephen Gaito)
--
-- Permission is hereby granted, free of charge, to any person
-- obtaining a copy of this software and associated documentation
-- files (the "Software"), to deal in the Software without
-- restriction, including without limitation the rights to use,
-- copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following
-- conditions:
--
--    The above copyright notice and this permission notice shall
--    be included in all copies or substantial portions of the
--    Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
-- HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE.

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/preamble.tex after line: 250

-- t-literate-progs templates

if not modules then modules = { } end
modules ['t-literate-progs-templates'] = {
    version   = 1.000,
    comment   = "Literate Programming in ConTeXt - templates",
    author    = "PerceptiSys Ltd (Stephen Gaito)",
    copyright = "PerceptiSys Ltd (Stephen Gaito)",
    license   = "MIT License"
}

thirddata               = thirddata               or {}
thirddata.literateProgs = thirddata.literateProgs or {}

local litProgs          = thirddata.literateProgs
litProgs.templates      = {}
local templates         = litProgs.templates
templates.mkiv          = {}
templates.lua           = {}
templates.templates     = {}
templates.lmsfile       = {}
templates.litProgsTable = {}

local table_insert = table.insert
local table_concat = table.concat

local addTemplate = litProgs.addTemplate

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/codeManipulation.tex after line: 200

addTemplate(
  'fixLitProgs',
  { 'litProgsName' },
[=[
\let\oldStart{{= litProgsName }}=\start{{= litProgsName }}
\unexpanded\def\start{{= litProgsName }}{
  \directlua{
    thirddata.literateProgs.markCodeOrigin(
      '{{= litProgsName }}'
    )
  }%
  \oldStart{{= litProgsName }}%
}
\let\oldStop{{= litProgsName }}=\stop{{= litProgsName }}
\unexpanded\def\stop{{= litProgsName }}{
  \oldStop{{= litProgsName }}%
  \directlua{
    thirddata.literateProgs.addCodeDispatcher(
      '{{= litProgsName }}',
      '_typing_'
    )
  }
}
\unexpanded\def\add{{= litProgsName }}Dependency#1#2{
  \directlua{
    thirddata.literateProgs.addCodeStreamDependency(
      '{{= litProgsName }}',
      '#1',
      '#2'
    )
  }
}
\unexpanded\def\clear{{= litProgsName }}#1{
  \directlua{
    thirddata.literateProgs.clearCodeStream(
      '{{= litProgsName }}',
      '#1'
    )
  }
}
\unexpanded\def\create{{= litProgsName }}File#1#2#3{
  \directlua{
    thirddata.literateProgs.createCodeFile(
      '{{= litProgsName }}',
      '#1',
      '#2',
      '#3'
    )
  }
}
\unexpanded\def\set{{= litProgsName }}Stream#1{
  \directlua{
    thirddata.literateProgs.setCodeStream(
      '{{= litProgsName }}',
      '#1'
    )
  }
}
\unexpanded\def\prepend{{= litProgsName}}#1{
  \directlua{
    thirddata.literateProgs.setPrepend(
      '{{= litProgsName }}',
      '#1',
      true
    )
  }
}
\unexpanded\def\append{{= litProgsName}}#1{
  \directlua{
    thirddata.literateProgs.setPrepend(
      '{{= litProgsName }}',
      '#1',
      false
    )
  }
}
]=]
)

