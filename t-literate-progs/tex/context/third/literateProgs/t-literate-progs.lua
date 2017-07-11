-- A Lua file

-- from file: preamble.tex after line: 50

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
litProgs.code    = {}
local code       = litProgs.code
code.mkiv        = {}
code.lua         = {}
code.templates   = {}
code.lakefile    = {}
code.lineModulus = 50

local tInsert = table.insert
local tRemove = table.remove
local tConcat = table.concat
local tSort   = table.sort
local tUnpack = table.unpack
local sFmt    = string.format
local sMatch  = string.match
local mFloor  = math.floor
local toStr   = tostring

-- from file: preamble.tex after line: 100

local function markMkIVCodeOrigin()
  code['MkIVCode']     = code['MkIVCode'] or { }
  local codeType       = code['MkIVCode']
  local codeStream     = codeType.curCodeStream or 'default'
  codeType[codeStream] = codeType[codeStream] or { }
  codeStream           = codeType[codeStream]
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

local function markLuaCodeOrigin()
  code['LuaCode']      = code['LuaCode'] or { }
  local codeType       = code['LuaCode']
  local codeStream     = codeType.curCodeStream or 'default'
  codeType[codeStream] = codeType[codeStream] or { }
  codeStream           = codeType[codeStream]
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
  code['LuaTemplate']  = code['LuaTemplate'] or { }
  local codeType       = code['LuaTemplate']
  local codeStream     = codeType.curCodeStream or 'default'
  codeType[codeStream] = codeType[codeStream] or { }
  codeStream           = codeType[codeStream]
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
  code['CHeader']      = code['CHeader'] or { }
  local codeType       = code['CHeader']
  local codeStream     = codeType.curCodeStream or 'default'
  codeType[codeStream] = codeType[codeStream] or { }
  codeStream           = codeType[codeStream]
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
  code['CCode']        = code['CCode'] or { }
  local codeType       = code['CCode']
  local codeStream     = codeType.curCodeStream or 'default'
  codeType[codeStream] = codeType[codeStream] or { }
  codeStream           = codeType[codeStream]
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

-- from file: rendering.tex after line: 50

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

-- from file: rendering.tex after line: 150

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

-- from file: rendering.tex after line: 300

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

-- from file: rendering.tex after line: 350

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

-- from file: rendering.tex after line: 400

local function navigateToTemplate(templatePath)
  litProgs.templates = litProgs.templates or { }
  local curTable = litProgs.templates
  for i, templateDir in ipairs(templatePath) do
    curTable[templateDir] = curTable[templateDir] or { }
    curTable = curTable[templateDir]
  end
  return curTable
end

litProgs.navigateToTemplate = navigateToTemplate

-- from file: rendering.tex after line: 450

local function addTemplate(templatePathStr, templateArgs, templateStr)
  local templatePath = parseTemplatePath(templatePathStr)
  if not templatePath then return nil end
  local templateTable    = navigateToTemplate(templatePath)
  templateTable.path     = templatePathStr
  templateTable.args     = templateArgs
  templateTable.template = parseTemplate(templateStr)
end

litProgs.addTemplate = addTemplate

-- from file: rendering.tex after line: 550

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

-- from file: rendering.tex after line: 600

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

-- from file: rendering.tex after line: 800

local function splitString(aString)
  local theSplitStr = { }
  for aLine in aString:gmatch('([^\n\r]+)[\n\r]*') do
    tInsert(theSplitStr, aLine)
  end
  return theSplitStr
end

litProgs.splitString = splitString

-- from file: rendering.tex after line: 800

local function renderCodeFile(aFilePath, codeTable)
  local outFile = io.open(aFilePath, 'w')
  outFile:write(tConcat(codeTable, '\n\n'))
  outFile:close()
end

-- from file: codeManipulation.tex after line: 200

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

-- from file: codeManipulation.tex after line: 300

local function setOriginMarker(aCodeType, aCodeStream, anOriginMarker)
  if type(litProgs[anOriginMarker]) == 'function' then
    code[aCodeType] = code[aCodeType] or { }
    local codeType  = code[aCodeType]
    if aCodeStream then
      codeType[aCodeStream] = codeType[aCodeStream] or { }
      local codeStream = codeType[aCodeStream]
      codeStream['markOrigin'] = litProgs[anOriginMarker]
    else
      codeType['markOrigin'] = litProgs[anOriginMarker]
    end
  end
end

litProgs.setOriginMarker = setOriginMarker

local function markCodeOrigin(aCodeType)
  code[aCodeType]        = code[aCodeType] or { }
  local codeType         = code[aCodeType]
  codeType.curCodeStream = codeType.curCodeStream or 'default'
  local aCodeStream      = codeType.curCodeStream
  codeType[aCodeStream]  = codeType[aCodeStream] or { }
  local codeStream       = codeType[aCodeStream]
  codeStream.fileName    = status.filename
  codeStream.startLine   = status.linenumber
end

litProgs.markCodeOrigin = markCodeOrigin

local function setCodeStream(aCodeType, aCodeStream)
  code[aCodeType]        = code[aCodeType] or { }
  local codeType         = code[aCodeType]
  aCodeStream            = aCodeStream or 'default'
  codeType.curCodeStream = aCodeStream
end

litProgs.setCodeStream = setCodeStream

local function setPrepend(aCodeType, aCodeStream)
  code[aCodeType]        = code[aCodeType] or { }
  local codeType         = code[aCodeType]
  aCodeStream            = aCodeStream or 'default'
  codeType.curCodeStream = aCodeStream
  codeType[aCodeStream]  = codeType[aCodeStream] or { }
  local codeStream       = codeType[aCodeStream]
  codeStream.prepend     = true
end

litProgs.setPrepend = setPrepend

local function addCode(aCodeType, bufferName)
  local bufferContents  =
    buffers.getcontent(bufferName):gsub("\13", "\n")

  code[aCodeType]       = code[aCodeType] or { }
  local codeType        = code[aCodeType]
  local aCodeStream     = codeType.curCodeStream or 'default'
  codeType[aCodeStream] = codeType[aCodeStream] or { }
  local codeStream      = codeType[aCodeStream]

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

litProgs.addCode = addCode

-- from file: codeManipulation.tex after line: 450

function litProgs.createCodeFile(aCodeType,
                                 aCodeStream,
                                 aFilePath,
                                 aFileHeader)
  local theCode = code[aCodeType]
  if #aCodeStream < 1 then aCodeStream = 'default' end
  if theCode then theCode = theCode[aCodeStream] end
  if theCode and 0 < #aFilePath then
    local outFile = io.open(aFilePath, 'w')
    if 0 < #aFileHeader then
      if aFileHeader:match('[Cc][Oo][Nn][Tt][Ee][Xx][Tt]') then
        outFile:write('% ')
      end
      outFile:write(aFileHeader)
      outFile:write('\n\n')
    end
    outFile:write(tConcat(theCode, '\n\n'))
    outFile:close()
  end
end