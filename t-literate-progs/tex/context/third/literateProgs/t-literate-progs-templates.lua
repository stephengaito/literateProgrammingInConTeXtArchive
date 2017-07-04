-- A Lua template file

-- from file: preamble.tex after line: 50

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
  \dosingleempty\doStart{{= litProgsName }}%
}
\unexpanded\def\doStart{{= litProgsName }}[#1]{%
  \iffirstargument%
    \doStart{{= litProgsName }}Single{#1}%
  \else
    \doStart{{= litProgsName }}Zero%
  \fi%
}
\unexpanded\def\doStart{{= litProgsName }}Single#1{%
  \directlua{thirddata.literateProgs.setCodeStream('#1')}%
  \oldStart{{= litProgsName }}%
}
\unexpanded\def\doStart{{= litProgsName }}Zero{%
  \doStart{{= litProgsName }}Single{default}%
}
\let\oldStop{{= litProgsName }}=\stop{{= litProgsName }}
\unexpanded\def\stop{{= litProgsName }}{%
  \oldStop{{= litProgsName }}%
  \directlua{
    thirddata.literateProgs.addCode(
      '{{= litProgsName }}',
      '_typing_'
    )
  }
}
\unexpanded\def\create{{= litProgsName }}File#1#2{%
  \directlua{
    thirddata.literateProgs.createCodeFile(
      '{{= litProgsName }}',
      '#1',
      '#2'
    )
  }
}
]=]
)