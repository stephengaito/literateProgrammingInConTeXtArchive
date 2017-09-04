-- A Lua template file

-- from file: preamble.tex after line: 200

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
templates.lakefile      = {}
templates.litProgsTable = {}

local table_insert = table.insert
local table_concat = table.concat

local addTemplate = litProgs.addTemplate

-- from file: codeManipulation.tex after line: 150

addTemplate(
  'fixLitProgs',
  { 'litProgsName' },
[=[
\let\oldStart{{= litProgsName }}=\start{{= litProgsName }}
\unexpanded\def\start{{= litProgsName }}{%
  \directlua{
    thirddata.literateProgs.markCodeOrigin(
      '{{= litProgsName }}'
    )
  }%
  \oldStart{{= litProgsName }}%
}
\let\oldStop{{= litProgsName }}=\stop{{= litProgsName }}
\unexpanded\def\stop{{= litProgsName }}{%
  \oldStop{{= litProgsName }}%
  \directlua{
    if thirddata.literateProgs.add{{= litProgsName }} ~= nil then
      thirddata.literateProgs.add{{= litProgsName }}(
        '_typing_'
      )
    else
      thirddata.literateProgs.addCode(
        '{{= litProgsName }}',
        '_typing_'
      )
    end
  }
}
\unexpanded\def\create{{= litProgsName }}File#1#2#3{%
  \directlua{
    thirddata.literateProgs.createCodeFile(
      '{{= litProgsName }}',
      '#1',
      '#2',
      '#3'
    )
  }
}
\unexpanded\def\set{{= litProgsName }}Stream#1{%
  \directlua{
    thirddata.literateProgs.setCodeStream(
      '{{= litProgsName }}',
      '#1'
    )
  }
}
\unexpanded\def\prepend{{= litProgsName}}#1{%
  \directlua{
    thirddata.literateProgs.setPrepend(
      '{{= litProgsName }}',
      '#1'
    )
  }
}
]=]
)