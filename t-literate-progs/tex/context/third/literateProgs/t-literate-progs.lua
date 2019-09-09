-- A Lua file

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/conclusion.tex after line: 0

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

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/preamble.tex after line: 50

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

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/preamble.tex after line: 50

-- This is the lua code associated with t-literate-progs.mkiv

if not modules then modules = { } end
modules ['t-literate-progs'] = {
    version   = 1.000,
    comment   = "Literate Programming in ConTeXt - lua",
    author    = "PerceptiSys Ltd (Stephen Gaito)",
    copyright = "PerceptiSys Ltd (Stephen Gaito)",
    license   = "MIT License"
}

thirddata               = thirddata               or {}
thirddata.literateProgs = thirddata.literateProgs or {}

local litProgs   = thirddata.literateProgs
litProgs.code    = litProgs.code or {}
local code       = litProgs.code
code.mkiv        = {}
code.mpiv        = {}
code.lua         = {}
code.templates   = {}
code.lmsfile     = {}
code.lineModulus = 50
litProgs.build   = litProgs.build or {}
local build      = litProgs.build

local tInsert = table.insert
local tRemove = table.remove
local tConcat = table.concat
local tSort   = table.sort
local tUnpack = table.unpack
local sFmt    = string.format
local sMatch  = string.match
local mFloor  = math.floor
local toStr   = tostring

local directorySeparator = package.config:sub(1,1)

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/preamble.tex after line: 50

local function setDefs(varVal, selector, defVal)
  if not defVal then defVal = { } end
  varVal[selector] = varVal[selector] or defVal
  return varVal[selector]
end

litProgs.setDefs = setDefs

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/preamble.tex after line: 100

local function shouldExist(varVal, selector, errorMessage)
  if not varVal[selector] then
    if not errorMessage then
      errorMessage = selector..' was not found but is required'
    end
    if type(errorMessage) == 'table' then
      errorMessage = tConcat(errorMessage)
    end
    error(errorMessage)
  end
  return varVal[selector]
end

litProgs.shouldExist = shouldExist

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/preamble.tex after line: 150

local function markMkIVCodeOrigin()
  local codeType       = setDefs(code, 'MkIVCode')
  local codeStream     = setDefs(codeType, 'curCodeStream', 'default')
  codeStream           = setDefs(codeType, codeStream)
  return sFmt('%% from file: %s after line: %s',
    codeStream.fileName,
    toStr(
      mFloor(
        codeStream.startLine/code.lineModulus
      )*code.lineModulus
    )
  )
end

litProgs.markMkIVCodeOrigin = markMkIVCodeOrigin

local function markMpIVCodeOrigin()
  local codeType       = setDefs(code, 'MpIVCode')
  local codeStream     = setDefs(codeType, 'curCodeStream', 'default')
  codeStream           = setDefs(codeType, codeStream)
  return sFmt('%% from file: %s after line: %s',
    codeStream.fileName,
    toStr(
      mFloor(
        codeStream.startLine/code.lineModulus
      )*code.lineModulus
    )
  )
end

litProgs.markMpIVCodeOrigin = markMpIVCodeOrigin

local function markLuaCodeOrigin()
  local codeType       = setDefs(code, 'LuaCode')
  local codeStream     = setDefs(codeType, 'curCodeStream', 'default')
  codeStream           = setDefs(codeType, codeStream)
  return sFmt('-- from file: %s after line: %s',
    codeStream.fileName,
    toStr(
      mFloor(
        codeStream.startLine/code.lineModulus
      )*code.lineModulus
    )
  )
end

litProgs.markLuaCodeOrigin = markLuaCodeOrigin

local function markLuaTemplateOrigin()
  local codeType       = setDefs(code, 'LuaTemplate')
  local codeStream     = setDefs(codeType, 'curCodeStream', 'default')
  codeStream           = setDefs(codeType, codeStream)
  return sFmt('-- from file: %s after line: %s',
    codeStream.fileName,
    toStr(
      mFloor(
        codeStream.startLine/code.lineModulus
      )*code.lineModulus
    )
  )
end

litProgs.markLuaTemplateOrigin = markLuaTemplateOrigin

local function markCHeaderOrigin()
  local codeType       = setDefs(code, 'CHeader')
  local codeStream     = setDefs(codeType, 'curCodeStream', 'default')
  codeStream           = setDefs(codeType, codeStream)
  return sFmt('// from file: %s after line: %s',
    codeStream.fileName,
    toStr(
      mFloor(
        codeStream.startLine/code.lineModulus
      )*code.lineModulus
    )
  )
end

litProgs.markCHeaderOrigin = markCHeaderOrigin

local function markCCodeOrigin()
  local codeType       = setDefs(code, 'CCode')
  local codeStream     = setDefs(codeType, 'curCodeStream', 'default')
  codeStream           = setDefs(codeType, codeStream)
  return sFmt('// from file: %s after line: %s',
    codeStream.fileName,
    toStr(
      mFloor(
        codeStream.startLine/code.lineModulus
      )*code.lineModulus
    )
  )
end

litProgs.markCCodeOrigin = markCCodeOrigin

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/components.tex after line: 0

local function setCodeOnly(codeOnlyBoolean)
  if codeOnlyBoolean then
    texio.write_nl('setCodeOnly to true')
  else
    texio.write_nl('setCodeOnly to false')
  end
  litProgs.codeOnly = codeOnlyBoolean
  if litProgs.codeOnly then
    texio.write_nl('setCodeOnly now true')
  else
    texio.write_nl('setCodeOnly now false')
  end
end

litProgs.setCodeOnly = setCodeOnly

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/components.tex after line: 150

local showMessages = false

local function showLitProgsMessages(aShowMessages)
  showMessages = aShowMessages
end

litProgs.showLitProgsMessages = showLitProgsMessages

local insideComponent = {}
insideComponent['component']   = 0
insideComponent['environment'] = 0
insideComponent['product']     = 0
insideComponent['project']     = 0

local litProgsPaths   = {}
local pathSeparator = package.config:sub(1, 1)

local function lastLitProgsPath()
  return litProgsPaths[#litProgsPaths] or ""
end

litProgs.lastLitProgsPath = lastLitProgsPath

local function pushLitProgsPath(aFullPath)
  if showMessages then
    texio.write_nl('pushLitProgsPath('..aFullPath..')')
  end
  local aFullPathDir =
    aFullPath:gsub('[^'..pathSeparator..']+$', '')
  if showMessages then
    texio.write_nl('  aFullPathDir: ['..aFullPathDir..']')
  end
  if aFullPathDir:sub(-1) ~= '/' then
    aFullPathDir = aFullPathDir..pathSeparator
  end
  tInsert(litProgsPaths, aFullPathDir)
  if showMessages then
    for i, aPath in ipairs(litProgsPaths) do
      texio.write_nl('litProgsPaths['..toStr(i)..']: ['..aPath..']')
    end
  end
end

-- repeat after me... this WILL break!!!
--
-- the use of environments.arguments.fulljobname
-- was infered from grep'ing the experimental distribution
-- for fulljobname and finding it defined in the
-- the environment table.
-- (defined in core-sys.lua)
--
pushLitProgsPath(file.collapsepath(environment.arguments.fulljobname,true))

local function popLitProgsPath()
  if showMessages then
    texio.write_nl('popLitProgsPath()')
  end
  tRemove(litProgsPaths)
  if showMessages then
    for i, aPath in ipairs(litProgsPaths) do
      texio.write_nl('litProgsPaths['..toStr(i)..']: ['..aPath..']')
    end
  end
  if showMessages then
    texio.write_nl('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
  end
end

litProgs.popLitProgsPath = popLitProgsPath

local function findLitProgsPath(curBasePath, componentPath, origBasePath)
  if showMessages then
    texio.write_nl('findLitProgsPath(['..curBasePath..'],['..componentPath..'],['..origBasePath..'])')
  end
  local potentialPath =
    file.collapsepath(curBasePath..componentPath, true)
  if lfs.attributes(potentialPath..'.tex', 'mode') == 'file' then
    if showMessages then
      texio.write_nl('found: ['..potentialPath..']')
    end
    return potentialPath
  end
  potentialPath =
    file.collapsepath(curBasePath..'doc/'..componentPath, true)
  if lfs.attributes(potentialPath..'.tex', 'mode') == 'file' then
    if showMessages then
      texio.write_nl('found: ['..potentialPath..']')
    end
    return potentialPath
  end
  if curBasePath == '' or curBasePath == pathSeparator then
    texio.write_nl('no path found using: ['..origBasePath..componentPath..']')
    return file.collapsepath(origBasePath..componentPath, true)
  end
  local newCurBasePath =
    curBasePath:gsub('[^'..pathSeparator..']+'..pathSeparator..'$','')
  return findLitProgsPath(newCurBasePath, componentPath, origBasePath)
end

local function litProgsComponent(componentType, componentPath)
  if showMessages then
    texio.write_nl('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
    texio.write_nl('litProgsComponent(['..componentType..'],['..componentPath..'])')
  end
  if componentType == 'environment' and 1 < insideComponent['component'] then
    -- do nothing
  else
    -- we are either NOT an environment
    -- OR we are an environment but inside the first start/stop component pair
    local basePath = lastLitProgsPath()
    local thisComponentPath = findLitProgsPath(basePath, componentPath, basePath)
    if showMessages then
      texio.write_nl(' thisComponentPath: ['..thisComponentPath..']')
    end
    pushLitProgsPath(thisComponentPath)
    tex.print({
      '\\'..componentType..' '..thisComponentPath,
      '\\popLitProgsPath'
    })
  end
end

litProgs.litProgsComponent = litProgsComponent

local function startLitProgsComponent(componentType, componentName)
  if showMessages then
    texio.write_nl('startLitProgsComponent(['..componentType..'],['..componentName..']')
    for k,v in pairs(insideComponent) do
      texio.write_nl('insideComponent['..k..'] = '..toStr(v))
    end
  end
  if insideComponent[componentType] < 1 then
    tex.print('\\start'..componentType..' '..componentName..'\\relax')
  end
  insideComponent[componentType] = insideComponent[componentType] + 1
  if showMessages then
    texio.write_nl(
      '\\startLitProgsComponent('..componentType..')'..
      '['..toStr(insideComponent[componentType])..']'
    )
  end
end

litProgs.startLitProgsComponent = startLitProgsComponent

local function stopLitProgsComponent(componentType)
  if showMessages then
    texio.write_nl('stopLitProgsComponent(['..componentType..']')
    texio.write_nl(
      '\\stopLitProgsComponent('..componentType..')'..
      '['..toStr(insideComponent[componentType])..']'
    )
  end
  insideComponent[componentType] = insideComponent[componentType] - 1
  if showMessages then
    for k,v in pairs(insideComponent) do
      texio.write_nl('insideComponent['..k..'] = '..toStr(v))
    end
  end
  if insideComponent[componentType] < 1 then
    if insideComponent[componentType] < 0 then
      texio.write_nl('ERRROR: unbalanced number of \\stop'..componentType)
    end
    if showMessages then
      texio.write_nl('CALLING \\stop'..componentType)
    end
    tex.print('\\stop'..componentType..'\\relax')
  end
end

litProgs.stopLitProgsComponent = stopLitProgsComponent

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/components.tex after line: 350

local function litProgsRecurseComponent(componentType, basePath, docDir, componentName)
  if litProgs and litProgs.addLmsfileSubDirectory then
    litProgs.addLmsfileSubDirectory(basePath)
  end
  if not litProgs.codeOnly then
    litProgsComponent(
      componentType,
      makePath{ '..', basePath, docDir, componentName}
    )
  end
end

litProgs.litProgsRecurseComponent = litProgsRecurseComponent

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/rendering.tex after line: 50

local function compareKeyValues(a, b)
  return (a[1] < b[1])
end

local function prettyPrint(anObj, indent)
  local result = ""
  indent = indent or ""
  if type(anObj) == 'nil' then
    result = 'nil'
  elseif type(anObj) == 'boolean' then
    if anObj then result = 'true' else result = 'false' end
  elseif type(anObj) == 'number' then
    result = toStr(anObj)
  elseif type(anObj) == 'string' then
    result = '"'..anObj..'"'
  elseif type(anObj) == 'function' then
    result = toStr(anObj)
  elseif type(anObj) == 'userdata' then
    result = toStr(anObj)
  elseif type(anObj) == 'thread' then
    result = toStr(anObj)
  elseif type(anObj) == 'table' then
    local origIndent = indent
    indent = indent..'  '
    result = '{\n'
    for i, aValue in ipairs(anObj) do
      result = result..indent..prettyPrint(aValue, indent)..',\n'
    end
    local theKeyValues = { }
    for aKey, aValue in pairs(anObj) do
      if type(aKey) ~= 'number' or aKey < 1 or #anObj < aKey then
        tInsert(theKeyValues,
          { prettyPrint(aKey), aKey, prettyPrint(aValue, indent) })
      end
    end
    tSort(theKeyValues, compareKeyValues)
    for i, aKeyValue in ipairs(theKeyValues) do
      result = result..indent..'['..aKeyValue[1]..'] = '..aKeyValue[3]..',\n'
    end
    result = result..origIndent..'}'
  else
    result = 'UNKNOWN TYPE: ['..toStr(anObj)..']'
  end
  return result
end

litProgs.prettyPrint = prettyPrint

lPPrint = prettyPrint

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/rendering.tex after line: 150

local function reportTemplateError(aTemplateStr, errMessage)
  texio.write_nl('---------------------------')
  texio.write_nl(errMessage)
  texio.write_nl("Template:")
  texio.write_nl(aTemplateStr)
  texio.write_nl("Ignoring this attribute action")
  texio.write_nl('---------------------------')
end

local function parseTemplate(aTemplateStr)
  local theTemplate = { }

  if type(aTemplateStr) == 'string' then
    -- we only do anything if we have been given
    -- an explicit string
    local position = 1
    while aTemplateStr:find('{{', position, true) do

      local endText, startChunk = aTemplateStr:find('{{', position, true)
      if position < endText then
        local textChunk = aTemplateStr:sub(position, endText-1)
        if textChunk and 0 < #textChunk then
          tInsert(theTemplate, textChunk)
        end
      end
      position = startChunk + 1

      local endChunk, startText = aTemplateStr:find('}}', position, true)
      if position < endChunk then
        local luaChunk = aTemplateStr:sub(position, endChunk-1)
        if luaChunk and 0 < #luaChunk then
          local actionType = luaChunk:sub(1,1)
          local luaChunk = luaChunk:sub(2)
          local arguments = { }
          for anArg in luaChunk:gmatch('[^,]+') do
            tInsert(arguments, anArg:match("^%s*(.-)%s*$"))
          end
          if actionType == '=' then
            if 0 < #arguments then
              tInsert(theTemplate, { 'reference', arguments[1] })
            else
              reportTemplateError(aTemplateStr,
                "No attribute specified"
              )
            end
          elseif actionType == '!' then
            if 0 < #arguments then
              tInsert(theTemplate, { 'application', arguments })
            else
              reportTemplateError(aTemplateStr,
                "No template specified"
              )
            end
          elseif actionType == '|' then
            if 2 < #arguments then
              tInsert(theTemplate, { 'mapping', arguments })
            else
              reportTemplateError(aTemplateStr,
                "No attribute, separator or template specified"
              )
            end
          else
            reportTemplateError(aTemplateStr,
              sFmt("Unknown template attribute action [%s]",
                actionType)
            )
          end
        end
      end
      position = startText + 1
    end

    if position <= #aTemplateStr then
      tInsert(theTemplate, aTemplateStr:sub(position))
    end
  end
  return theTemplate
end

litProgs.parseTemplate = parseTemplate

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/rendering.tex after line: 300

local function getReference(aReference, anEnv)
  if type(aReference) ~= 'string' then return nil end
  local redirect = aReference:sub(1,1)
  if redirect == '*' then
    local newRef = aReference:sub(2)
    local indirectRef = getReference(newRef, anEnv)
    if indirectRef and type(indirectRef) == 'string' then
      return getReference(indirectRef, anEnv)
    else
      return nil
    end
  end

  return anEnv[aReference]
end

litProgs.getReference = getReference

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/rendering.tex after line: 350

local function parseTemplatePath(templatePathStr, anEnv)
  if type(templatePathStr) ~= 'string' then
    texio.write_nl(
      sFmt("Expected [%s] to be a string.", tempaltePathStr)
    )
    texio.write_nl("Ignoring template.")
    return nil
  end
  if templatePathStr:sub(1,1) == '*' then
    local newTemplatePathStr = getReference(templatePathStr:sub(2), anEnv)
    if newTemplatePathStr then
      templatePathStr = newTemplatePathStr
    else
      texio.write_nl("ERROR: indirect parseTemplatePath")
      texio.write_nl("  could not dereference: ["..templatePathStr.."]")
      return { }
    end
  end
  local templatePath = { }
  for subTemplate in templatePathStr:gmatch('[^%.]+') do
    tInsert(templatePath, subTemplate)
  end
  return templatePath
end

litProgs.parseTemplatePath = parseTemplatePath

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/rendering.tex after line: 400

local function navigateToTemplate(templatePath)
  local curTable = setDefs(litProgs, 'templates')
  for i, templateDir in ipairs(templatePath) do
    curTable = setDefs(curTable, templateDir)
  end
  return curTable
end

litProgs.navigateToTemplate = navigateToTemplate

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/rendering.tex after line: 450

local function addTemplate(templatePathStr, templateArgs, templateStr)
  local templatePath = parseTemplatePath(templatePathStr)
  if not templatePath then return nil end
  local templateTable    = navigateToTemplate(templatePath)
  templateTable.path     = templatePathStr
  templateTable.args     = templateArgs
  templateTable.template = parseTemplate(templateStr)
end

litProgs.addTemplate = addTemplate

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/rendering.tex after line: 550

local function buildNewEnv(template, arguments, anEnv)
  if anEnv and anEnv.tracingOn then
    texio.write_nl('------buildNewEnv------')
    texio.write_nl('Formal arguments;')
    --texio.write_nl(prettyPrint(template.args))
    texio.write_nl(prettyPrint(template))
    texio.write_nl('Actual arguments:')
    texio.write_nl(prettyPrint(arguments))
    texio.write_nl('Old environment:')
    texio.write_nl(prettyPrint(anEnv))
  end
  if type(template)      ~= 'table' or
     type(template.args) ~= 'table' or
     type(arguments)     ~= 'table' or
     type(anEnv)         ~= 'table' then
    return { }
  end
  local formalArgs = template.args
  local newEnv = { }
  newEnv.tracingOn = anEnv.tracingOn
  for i, aFormalArg in ipairs(formalArgs) do
    newEnv[aFormalArg] = getReference(arguments[i], anEnv)
  end
  if anEnv.tracingOn then
    texio.write_nl('New environment:')
    texio.write_nl(prettyPrint(newEnv))
    texio.write_nl('-----------------------')
  end
  return newEnv
end

litProgs.buildNewEnv = buildNewEnv

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/rendering.tex after line: 600

local function renderer(aTemplate, anEnv)
  if anEnv.tracingOn then
    texio.write_nl('>>>>>>RENDERER>>>>>>')
    texio.write_nl('Path: '..aTemplate.path)
    texio.write_nl('Template:')
    texio.write_nl(prettyPrint(aTemplate))
    texio.write_nl('Environment:')
    texio.write_nl(prettyPrint(anEnv))
  end
  local resultStr = ""
  if type(aTemplate) == 'table' and
     type(aTemplate.template) == 'table' then
    local result = { }
    for i, aChunk in ipairs(aTemplate.template) do
      if type(aChunk) == 'string' then
        -- a simple litteral string... add it
        tInsert(result, aChunk)
      elseif type(aChunk) == 'table' and 2 <= #aChunk then
        local actionType = aChunk[1]
        local arguments  = aChunk[2]
        if actionType == 'reference' then
          if type(arguments) == 'string' then
            if anEnv.tracingOn then
              texio.write_nl('Reference action:')
              texio.write_nl('argument: ['..arguments..']')
            end
            local attrValue = getReference(arguments, anEnv)
            tInsert(result, toStr(attrValue))
          end
        elseif actionType == 'application' then
          if type(arguments) == 'table' and 1 < #arguments then
            arguments = { tUnpack(arguments) }
            local templatePath = tRemove(arguments, 1)
            if type(templatePath) == 'string' then
              if anEnv.tracingOn then
                texio.write_nl('Application action:')
                texio.write_nl('templatePath: ['..templatePath..']')
                texio.write_nl('   arguments: ['..tConcat(arguments,', ')..']')
              end
              templatePath   = parseTemplatePath(templatePath, anEnv)
              local template = navigateToTemplate(templatePath)
              local newEnv   = buildNewEnv(template, arguments, anEnv)
              local templateValue = renderer(template, newEnv)
              if type(templateValue) == 'string' then
                tInsert(result, templateValue)
              end
            end
          end
        elseif actionType == 'mapping' then
          if type(arguments) == 'table' and 4 <= #arguments then
            arguments = { tUnpack(arguments) }
            local attrList     = tRemove(arguments, 1)
            local separator    = tRemove(arguments, 1)
            local templatePath = tRemove(arguments, 1)
            local listArg      = tRemove(arguments, 1)
            tInsert(arguments, 1, listArg)
            if type(attrList)     == 'string' and
               type(separator)    == 'string' and
               type(templatePath) == 'string' and
               type(listArg)      == 'string' then
              if anEnv.tracingOn then
                texio.write_nl('Mapping action:')
                texio.write_nl('    attrList: ['..attrList..']')
                texio.write_nl('   separator: ['..separator..']')
                texio.write_nl('templatePath: ['..templatePath..']')
                texio.write_nl('     listArg: ['..listArg..']')
              end
              attrList       = getReference(attrList,  anEnv)
              separator      = getReference(separator, anEnv)
              templatePath   = parseTemplatePath(templatePath, anEnv)
              local template = navigateToTemplate(templatePath)
              local newEnv   = buildNewEnv(template, arguments, anEnv)
              if type(separator) ~= 'string' then
                separator = ''
              end
              if type(attrList) ~= 'table' then
                attrList = { attrList }
              end
              if type(attrList) == 'table' and 0 < #attrList then
                for i, anAttrValue in ipairs(attrList) do
                  if anEnv.tracingOn then
                    texio.write_nl('mapped arg: ['..toStr(anAttrValue)..']')
                  end
                  newEnv[listArg] = anAttrValue
                  local templateValue = renderer(template, newEnv)
                  if type(templateValue) == 'string' then
                    tInsert(result, templateValue)
                  end
                  if i < #attrList then
                    tInsert(result, separator)
                  end
                end
              end
            end
          end
        end
      end
    end
    resultStr = tConcat(result)
  end
  if anEnv.tracingOn then
    texio.write_nl('-------------------')
    texio.write_nl('Path: '..aTemplate.path)
    texio.write_nl("Result:")
    texio.write_nl(resultStr)
    texio.write_nl('<<<<<<RENDERER<<<<<<')
  end
  return resultStr
end

litProgs.renderer = renderer

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/rendering.tex after line: 800

local function splitString(aString)
  local theSplitStr = { }
  for aLine in aString:gmatch('([^\n\r]+)[\n\r]*') do
    tInsert(theSplitStr, aLine)
  end
  return theSplitStr
end

litProgs.splitString = splitString

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/rendering.tex after line: 800

local function renderCodeFile(aFilePath, codeTable)
  local outFile = io.open(aFilePath, 'w')
  outFile:write(tConcat(codeTable, '\n\n'))
  outFile:close()
end

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/codeManipulation.tex after line: 250

local function createFixLitProgs(theLitProgsName, aTracingOn)
  local theEnv = {
    litProgsName = theLitProgsName,
    tracingOn    = aTracingOn
  }
  local templatePath = litProgs.parseTemplatePath('fixLitProgs', theEnv)
  local theTemplate  = litProgs.navigateToTemplate(templatePath)
  local result       = litProgs.renderer(theTemplate, theEnv, true)
  result             = litProgs.splitString(result)
  tex.print(result)
  return result
end

litProgs.createFixLitProgs = createFixLitProgs

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/codeManipulation.tex after line: 400

local function setOriginMarker(aCodeType, aCodeStream, anOriginMarker)
  if type(litProgs[anOriginMarker]) == 'function' then
    local codeType  = setDefs(code, aCodeType)
    if aCodeStream then
      local codeStream = setDefs(codeType, aCodeStream)
      codeStream['markOrigin'] = litProgs[anOriginMarker]
    else
      codeType['markOrigin'] = litProgs[anOriginMarker]
    end
  end
end

litProgs.setOriginMarker = setOriginMarker

local function markCodeOrigin(aCodeType)
  local codeType         = setDefs(code, aCodeType)
  local aCodeStream      = setDefs(codeType, 'curCodeStream', 'default')
  local codeStream       = setDefs(codeType, aCodeStream)
  local homeDir          = os.getenv('HOME')
  local fileName         = status.filename
  if homeDir then
    fileName = fileName:gsub(homeDir, '~')
  end
  codeStream.fileName    = fileName
  codeStream.startLine   = status.linenumber
  tex.print({
   '\\blank[medium]\\noindent',
   '{\\darkgray '..aCodeType..' : '..aCodeStream..'}',
   ''
   })
end

litProgs.markCodeOrigin = markCodeOrigin

local function setCodeStream(aCodeType, aCodeStream)
  local codeType         = setDefs(code, aCodeType)
  aCodeStream            = aCodeStream or 'default'
  codeType.curCodeStream = aCodeStream
end

litProgs.setCodeStream = setCodeStream

local function setPrepend(aCodeType, aCodeStream, setValue)
  local codeType         = setDefs(code, aCodeType)
  aCodeStream            = aCodeStream or 'default'
  codeType.curCodeStream = aCodeStream
  local codeStream       = setDefs(codeType, aCodeStream)
  codeStream.prepend     = setValue
end

litProgs.setPrepend = setPrepend

local function addCodeDispatcher(aCodeType, bufferName)
  local bufferContents  =
    buffers.getcontent(bufferName):gsub("\13", "\n")

  if litProgs.addCode[aCodeType] ~= nil then
    litProgs.addCode[aCodeType](bufferContents)
  else
    litProgs.addCode.default(aCodeType, bufferContents)
  end
end

local function addCodeDefault(aCodeType, bufferContents)
  local codeType        = setDefs(code, aCodeType)
  local aCodeStream     = setDefs(codeType, 'curCodeStream', 'default')
  local codeStream      = setDefs(codeType, aCodeStream)

  local codeOrigin      = nil
    if type(codeStream['markOrigin']) == 'function' then
      codeOrigin =
        codeStream['markOrigin'](codeStream, aCodeType, aCodeStream)
    elseif type(codeType['markOrigin']) == 'function' then
      codeOrigin =
        codeType['markOrigin'](codeStream, aCodeType, aCodeStream)
    end

  if codeStream.prepend then
    tInsert(codeStream, 1, bufferContents)
    if codeOrigin then
      tInsert(codeStream, 1, codeOrigin)
    end
  else
    if codeOrigin then
      tInsert(codeStream, codeOrigin)
    end
    tInsert(codeStream, bufferContents)
  end
  codeStream.prepend = nil
end

litProgs.addCodeDispatcher = addCodeDispatcher
litProgs.addCode           = {}
litProgs.addCode.default   = addCodeDefault

local function addCodeStreamDependency(aCodeType, aCodeStream, aDependent)
  local codeType        = setDefs(code, aCodeType)
  local aCodeStream     = setDefs(codeType, 'curCodeStream', 'default')
  local codeStream      = setDefs(codeType, aCodeStream)
  local dependents      = setDefs(codeStream, 'dependents')
 
  tInsert(dependents, aDependent)
end

litProgs.addCodeStreamDependent = addCodeStreamDependent

local function clearCodeStream(aCodeType, aCodeStream)
  local codeType        = setDefs(code, aCodeType)
  local aCodeStream     = setDefs(codeType, 'curCodeStream', 'default')
  local codeStream      = setDefs(codeType, aCodeStream)

  codeStream = { }
end

litProgs.clearCodeStream = clearCodeStream

local function addMITLicense(aCodeType, commentStart, copyrightOwner)
  litProgs.markCodeOrigin(aCodeType)
  if (type(commentStart) == 'nil') or (string.len(commentStart) < 1) then
    commentStart = '%C'
  end
  copyright = { }
  tInsert(copyright, commentStart ..
    ' Copyright '..os.date('%Y')..' '..copyrightOwner)
  tInsert(copyright,  commentStart ..
    '')
  tInsert(copyright, commentStart ..
    ' Permission is hereby granted, free of charge, to any person')
  tInsert(copyright, commentStart ..
    ' obtaining a copy of this software and associated documentation')
  tInsert(copyright, commentStart ..
    ' files (the "Software"), to deal in the Software without')
  tInsert(copyright, commentStart ..
    ' restriction, including without limitation the rights to use,')
  tInsert(copyright, commentStart ..
    ' copy, modify, merge, publish, distribute, sublicense, and/or sell')
  tInsert(copyright, commentStart ..
    ' copies of the Software, and to permit persons to whom the')
  tInsert(copyright, commentStart ..
    ' Software is furnished to do so, subject to the following')
  tInsert(copyright, commentStart ..
    ' conditions:')
  tInsert(copyright, commentStart ..
    '')
  tInsert(copyright, commentStart ..
    '    The above copyright notice and this permission notice shall')
  tInsert(copyright, commentStart ..
    '    be included in all copies or substantial portions of the')
  tInsert(copyright, commentStart ..
    '    Software.')
  tInsert(copyright, commentStart ..
    '')
  tInsert(copyright, commentStart ..
    ' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,')
  tInsert(copyright, commentStart ..
    ' EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES')
  tInsert(copyright, commentStart ..
    ' OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND')
  tInsert(copyright, commentStart ..
    ' NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT')
  tInsert(copyright, commentStart ..
    ' HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,')
  tInsert(copyright, commentStart ..
    ' WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING')
  tInsert(copyright, commentStart ..
    ' FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR')
  tInsert(copyright, commentStart ..
    ' OTHER DEALINGS IN THE SOFTWARE.')

  copyright = tConcat(copyright, "\n")

  if litProgs.addCode[aCodeType] ~= nil then
    litProgs.addCode[aCodeType](copyright)
  else
    litProgs.addCode.default(aCodeType, copyright)
  end
end

litProgs.addMITLicense = addMITLicense

local function addApacheLicense(aCodeType, commentStart, copyrightOwner)
  litProgs.markCodeOrigin(aCodeType)
  if (type(commentStart) == 'nil') or (string.len(commentStart) < 1) then
    commentStart = '%C'
  end
  copyright = { }
  tInsert(copyright, commentStart ..
    ' Copyright '..os.date('%Y')..' '..copyrightOwner)
  tInsert(copyright,  commentStart ..
    '')
  tInsert(copyright, commentStart ..
    ' Licensed under the Apache License, Version 2.0 (the "License");')
  tInsert(copyright, commentStart ..
    ' you may not use this file except in compliance with the License.')
  tInsert(copyright, commentStart ..
    ' You may obtain a copy of the License at')
  tInsert(copyright, commentStart ..
    '')
  tInsert(copyright, commentStart ..
    '    http://www.apache.org/licenses/LICENSE-2.0')
  tInsert(copyright, commentStart ..
    '')
  tInsert(copyright, commentStart ..
    ' Unless required by applicable law or agreed to in writing,')
  tInsert(copyright, commentStart ..
    ' software distributed under the License is distributed on an "AS')
  tInsert(copyright, commentStart ..
    ' IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either')
  tInsert(copyright, commentStart ..
    ' express or implied. See the License for the specific language')
  tInsert(copyright, commentStart ..
    ' governing permissions and limitations under the License. end')
  copyright = tConcat(copyright, "\n")

  if litProgs.addCode[aCodeType] ~= nil then
    litProgs.addCode[aCodeType](copyright)
  else
    litProgs.addCode.default(aCodeType, copyright)
  end
end

litProgs.addApacheLicense = addApacheLicense

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/codeManipulation.tex after line: 700

build.srcTypes = build.srcTypes or { }
build.srcTypes['MkIVCode']    = 'ctxModule'
build.srcTypes['MpIVCode']    = 'ctxModule'
build.srcTypes['LuaCode']     = 'ctxModule'
build.srcTypes['LuaTemplate'] = 'ctxModule'
build.srcTypes['CHeader']     = 'cHeader'
build.srcTypes['CCode']       = 'cCode'
build.srcTypes['Lmsfile']     = 'lmsfile'

local function diSimpPrefix()
  if thirddata.diSimp and thirddata.diSimp.lastDiSimpPath then
    return thirddata.diSimp.lastDiSimpPath()
  end
  return ""
end

local function createCodeFile(aCodeType,
                              aCodeStream,
                              aFilePath,
                              aFileHeader)
  local theCode = code[aCodeType]
  if #aCodeStream < 1 then aCodeStream = 'default' end
  if theCode then theCode = theCode[aCodeStream] end

  if not theCode then
    texio.write('\nERROR: no code found for code stream ['..aCodeStream..'] and code type ['..aCodeType..']\n\n')
    return
  end
  if #aFilePath < 1 then
    texio.write('\nERROR: no file name provided for code type ['..aCodeType..']\n\n')
    return
  end

  theCodeStr = tConcat(theCode, '\n\n')
  while 0 < #theCode do tRemove(theCode) end

  build.srcTargets = build.srcTargets or { }
  local srcTargets = build.srcTargets

  local srcType       = build.srcTypes[aCodeType] or 'default'
  srcTargets[srcType] = srcTargets[srcType] or { }

  tInsert(srcTargets[srcType], aFilePath)

  build.dirTargets = build.dirTargets or { }
  local dirTargets = build.dirTargets
 
  for aPathSegment in aFilePath:gmatch('[^%'..directorySeparator..']+') do
    tInsert(dirTargets, aPathSegment)
  end
  tRemove(dirTargets) -- remove the last item
 
  texio.write_nl('directory targets:')
  texio.write_nl(prettyPrint(dirTargets))
  texio.write_nl('diSimpPrefix: ['..diSimpPrefix()..']')
  texio.write_nl('aFilePath: ['..aFilePath..']')

  aFilePath = file.collapsepath(aFilePath, true)
  local outFile = io.open(aFilePath, 'w')
  if outFile then
    texio.write_nl('creating code file: ['..aFilePath..']')
    if 0 < #aFileHeader then
      if aFileHeader:match('[Cc][Oo][Nn][Tt][Ee][Xx][Tt]') then
        outFile:write('% ')
      elseif aFileHeader:match('^!/.*bin') then
        outFile:write('#')
      end
      outFile:write(aFileHeader)
      outFile:write('\n\n')
    end
    outFile:write(theCodeStr)
    outFile:write('\n\n')
    outFile:close()
  else
    texio.write("\nERROR: could NOT open ["..aFilePath.."]\n")
  end
end

litProgs.createCodeFile = createCodeFile

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/codeManipulation.tex after line: 900

local function cHeaderIncludeGuard(aCodeStream, aGuard)
  setCodeStream('CHeader', aCodeStream)
  markCodeOrigin('CHeader')
  setPrepend('CHeader', aCodeStream, true)
  local bufferContents = [=[
#ifndef ]=]..aGuard..[=[_H
#define ]=]..aGuard..[=[_H
]=]
  addCodeDefault('CHeader', bufferContents)
  setPrepend('CHeader', aCodeStream, false)
  bufferContents = '#endif'
  addCodeDefault('CHeader', bufferContents)
end

thirddata.literateProgs.cHeaderIncludeGuard = cHeaderIncludeGuard

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/pathManipulation.tex after line: 0

directorySeparator = package.config:sub(1,1)

function makePath(pathTable)
  return tConcat(pathTable, directorySeparator)
end

function replaceEnvironmentVarsInString( aPath )
  aNewPath = aPath:gsub('<([^>]+)>', os.env)
  return(aNewPath)
end

function setEnvironment(envKey, envValue)
  os.setenv(
    envKey,
    replaceEnvironmentVarsInString(envValue)
  )
end

litProgs.setEnvironment = setEnvironment

function setEnvironmentDefault(envKey, envValue)
  if type(os.getenv(envKey)) == 'nil' then
    os.setenv(
      envKey,
      replaceEnvironmentVarsInString(envValue)
    )
  end
end

litProgs.setEnvironmentDefault = setEnvironmentDefault

function clearEnvironment(envKey)
  os.setenv(envKey, nil)
end

litProgs.clearEnvironment = clearEnvironment

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/pathManipulation.tex after line: 50

replaceEnvironmentVarsInPath = replaceEnvironmentVarsInString
litProgs.replaceEnvironmentVarsInPath = replaceEnvironmentVarsInPath

function recursivelyFindFiles(aDir, aFilePattern, actionBlock)
  for aPath in lfs.dir(aDir) do
--    texio.write_nl('looking at ['..aPath..']')
    local fullPath = makePath{aDir, aPath}
    if not aPath:match('^%.+$') then
      if lfs.isdir(fullPath) then
        recursivelyFindFiles(fullPath, aFilePattern, actionBlock)
      elseif aPath:match(aFilePattern) then
        actionBlock(fullPath)
      end
    end
  end
end

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/lmsfiles.tex after line: 50

local function addMainDocument(aDocument)
  -- first mainDoc "wins"
  build.mainDoc = build.mainDoc or aDocument
end

litProgs.addMainDocument = addMainDocument

local function addSubDocument(aDocument)
  build.subDocs = build.subDocs or { }
  tInsert(build.subDocs, aDocument)
end

litProgs.addSubDocument = addSubDocument

local function ensureDirectoryExists(newDirectory)
--  newDirectory =
--    newDirectory:gsub('<HOME>', os.getenv('HOME'))
--  build.existingDirs = build.existingDirs or { }
  tInsert(build.existingDirs, newDirectory)
end

litProgs.ensureDirectoryExists = ensureDirectoryExists

local function addDocumentDirectory(aDirectory)
  texio.write_nl('addDocumentDir: curDir: ['..lfs.currentdir()..']')
  build.docDir   = aDirectory
end

litProgs.addDocumentDirectory = addDocumentDirectory

local function addLmsfileSubDirectory(aDirectory)
  build.lmsfileSubDirs = build.lmsfileSubDirs or { }
  tInsert(build.lmsfileSubDirs, aDirectory)
end

litProgs.addLmsfileSubDirectory = addLmsfileSubDirectory

local function addConTeXtModuleFile(aFile)
  build.srcTargets = build.srcTargets or { }
  local srcTargets = build.srcTargets
  srcTargets['ctxModule'] = srcTargets['ctxModule'] or { }
  tInsert(srcTargets['ctxModule'], aFile)
end

litProgs.addConTeXtModuleFile = addConTeXtModuleFile

local function addConTeXtModuleDirectory(aDirectory)
  build.contextModuleDir = aDirectory
end

litProgs.addConTeXtModuleDirectory = addConTeXtModuleDirectory

local function addCCodeProgram(aProgram)
  build.cCodePrograms = build.cCodePrograms or { }
  tInsert(build.cCodePrograms, aProgram)
end

litProgs.addCCodeProgram = addCCodeProgram

local function addCCodeLibDirectory(aDirectory)
  build.cCodeLibDirs = build.cCodeLibDirs or { }
  tInsert(build.cCodeLibDirs, aDirectory)
end

litProgs.addCCodeLibDirectory = addCCodeLibDirectory

local function addCCodeLib(aLib)
  build.cCodeLibs = build.cCodeLibs or { }
  tInsert(build.cCodeLibs, aLib)
end

litProgs.addCCodeLib = addCCodeLib

local function addCCodeTargets(aCodeStream)
  litProgs.setCodeStream('Lmsfile', aCodeStream)
  build.cCodePrograms = build.cCodePrograms or { }
  litProgs.markCodeOrigin('Lmsfile')
  local lmsfile = {}
  tInsert(lmsfile, "require 'lms.c'\n")
  tInsert(lmsfile, "cTargets = c.targets(lpTargets, {")
  tInsert(lmsfile, "  programs = {")
  for i, aProgram in ipairs(build.cCodePrograms) do
    tInsert(lmsfile, "    '"..aProgram.."',")
  end
  tInsert(lmsfile, "  },")

--  srcTargets.joylolCode = srcTargets.joylolCode or { }
--  local joylolCode      = srcTargets.joylolCode
--  tInsert(lmsfile, "  joylolCodeFiles = {")
--  for i, aSrcFile in ipairs(joylolCode) do
--    tInsert(lmsfile, "    '"..aSrcFile.."',")
--  end
--  tInsert(lmsfile, "  },")

  if build.cCodeLibDirs then
    tInsert(lmsfile, "  cCodeLibDirs = {")
    for i, aLibDir in ipairs(build.cCodeLibDirs) do
      tInsert(lmsfile, "    '"..aLibDir.."',")
    end
    tInsert(lmsfile, "  },")
  end
  if build.cCodeLibs then
    tInsert(lmsfile, "  cCodeLibs = {")
    for i, aLib in ipairs(build.cCodeLibs) do
      tInsert(lmsfile, "    '"..aLib.."',")
    end
    tInsert(lmsfile, "  },")
  end

--  tInsert(lmsfile, "  coAlgLibs = {")
--  for i, aCoAlgDependency in ipairs(build.coAlgDependencies) do
--    tInsert(lmsfile, "    '"..aCoAlgDependency.."',")
--  end
--  tInsert(lmsfile, "  },")
  tInsert(lmsfile, "})")
--  litProgs.setPrepend('Lmsfile', aCodeStream, true)
  litProgs.addCode.default('Lmsfile', tConcat(lmsfile, '\n'))
end

litProgs.addCCodeTargets = addCCodeTargets

-- from file: ~/ExpositionGit/tools/conTeXt/literateProgrammingInConTeXt/t-literate-progs/doc/context/third/literateProgs/lmsfiles.tex after line: 200

local function compileLmsfile(aCodeStream)
  setCodeStream('Lmsfile', aCodeStream)
  markCodeOrigin('Lmsfile')
  local lmsfile = {}
  tInsert(lmsfile, "require 'lms.contextDoc'\n")
  tInsert(lmsfile, "ctxTargets = contextDoc.targets{")
  tInsert(lmsfile, "  mainDoc        = '"..build.mainDoc.."',")
  tInsert(lmsfile, "  docDir         = '"..build.docDir.."',")
  tInsert(lmsfile, "  lmsfileSubDirs = {")
  build.lmsfileSubDirs = build.lmsfileSubDirs or { }
  for i, anLmsfileSubDir in ipairs(build.lmsfileSubDirs) do
    tInsert(lmsfile, "    '"..anLmsfileSubDir.."',")
  end
  tInsert(lmsfile, "  },")
  tInsert(lmsfile, "}")
  tInsert(lmsfile, "")
 
  tInsert(lmsfile, "require 'lms.litProgs'\n")
  tInsert(lmsfile, "lpTargets = litProgs.targets(ctxTargets, {")
 
  build.dirTargets = build.dirTargets or { }
  local dirTargets = build.dirTargets
 
  tInsert(lmsfile, "  directories = {")
  for i, aDir in ipairs(dirTargets) do
    tInsert(lmsfile, "    '"..aDir.."',")
  end
  tInsert(lmsfile, "  },")
 
  build.srcTargets = build.srcTargets or { }
  local srcTargets = build.srcTargets
 
  tInsert(lmsfile, "  autoGenerated = {")
  for aSrcType, someSrcFiles in pairs(srcTargets) do
    tInsert(lmsfile, "    "..aSrcType.."Files = {")
    for i, aSrcFile in ipairs(someSrcFiles) do
      tInsert(lmsfile, "      '"..aSrcFile.."',")
    end
    tInsert(lmsfile, "    },")
  end
 
  if build.cTestTargets then
    local cTestTargets = build.cTestTargets
    tInsert(lmsfile, "    cTestFiles = {")
    for i, aTestExec in ipairs(cTestTargets) do
      tInsert(lmsfile, "      '"..aTestExec..".c',")
    end
    tInsert(lmsfile, "    },")
  end
 
  tInsert(lmsfile, "    lmsfileFiles = {")
  tInsert(lmsfile, "      'lmsfile',")
  tInsert(lmsfile, "    },")
  tInsert(lmsfile, "  },")
  tInsert(lmsfile, "})")
  tInsert(lmsfile, "")
 
  if build.srcTargets.ctxModule and 0 < #build.srcTargets.ctxModule then
    tInsert(lmsfile, "require 'lms.contextMod'")
    tInsert(lmsfile, "")
    tInsert(lmsfile, "contextMod.targets(lpTargets, {")
      if build.contextModuleDir then
        tInsert(lmsfile, "  moduleDir = '"..build.contextModuleDir.."',")
      end
    tInsert(lmsfile, "})")
  end
  setPrepend('Lmsfile', aCodeStream, true)
  addCodeDefault('Lmsfile', tConcat(lmsfile, '\n'))
end

litProgs.compileLmsfile = compileLmsfile

local function addRecurseTargetsToLmsfile(aCodeStream)
  setCodeStream('Lmsfile', aCodeStream)
  markCodeOrigin('Lmsfile')
  addCodeDefault('Lmsfile', "\n\nrecurseTargets(ctxTargets)\n" )
end

litProgs.addRecurseTargetsToLmsfile = addRecurseTargetsToLmsfile

