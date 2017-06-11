-- A Lua file (the lua code associated with t-literate-progs.mkiv)

if not modules then modules = { } end
modules ['t-literate-progs'] = {
    version   = 1.000,
    comment   = "Literate Programming in ConTeXt - lua",
    author    = "PerceptiSys Ltd (Stephen Gaito)",
    copyright = "PerceptiSys Ltd (Stephen Gaito)",
    license   = "MIT License"
}

local pp = require('pl/pretty')
texio.write_nl('t-literate-progs.lua')
texio.write_nl('-------------------------')
texio.write_nl(pp.write(thirddata))
texio.write_nl('-------------------------')

thirddata               = thirddata               or {}
thirddata.literateProgs = thirddata.literateProgs or {}

local litProgs  = thirddata.literateProgs
litProgs.code   = {}
local code      = litProgs.code
code.mkiv       = {}
code.lua        = {}
code.templates  = {}
code.lakefile   = {}

local pp = require('pl/pretty')
local tInsert = table.insert
local tRemove = table.remove
local tConcat = table.concat
local sFmt    = string.format
local sMatch  = string.match
local toStr   = tostring

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

local function parseTemplatePath(templatePathStr, anEnv)
  if type(templatePathStr) ~= 'string' then
    texio.write_nl(
      sFmt("Expected [%s] to be a string.", tempaltePathStr)
    )
    texio.write_nl("Ignoring template.")
    return nil
  end
  if templatePathStr:sub(1,1) == '*' then
    templatePathStr = getReference(templatePathStr:sub(2), anEnv)
  end
  local templatePath = { }
  for subTemplate in templatePathStr:gmatch('[^%.]+') do
    tInsert(templatePath, subTemplate)
  end
  return templatePath
end

litProgs.parseTemplatePath = parseTemplatePath

local function navigateToTemplateTable(templatePath)
  litProgs.templates = litProgs.templates or { }
  local curTable = litProgs.templates
  for i, templateDir in ipairs(templatePath) do
    curTable[templateDir] = curTable[templateDir] or { }
    curTable = curTable[templateDir]
  end
  return curTable
end

litProgs.navigateToTemplateTable = navigateToTemplateTable

function litProgs.addTemplate(templatePath, templateArgs, templateStr)
  templatePath = parseTemplatePath(templatePath)
  if not templatePath then return nil end
  local templateTable    = navigateToTemplateTable(templatePath)
  templateTable.args     = templateArgs
  templateTable.template = parseTemplate(templateStr)
end

local function buildNewEnv(template, arguments, anEnv)
  if type(template)      ~= 'table' or
     type(template.args) ~= 'table' or
     type(arguments)     ~= 'table' or
     type(anEnv)         ~= 'table' then
    return { }
  end
  local formalArgs = template.args
  local newEnv = { }
  for i, aFormalArg in ipairs(formalArgs) do
    newEnv[aFormalArg] = getReference(arguments[i], anEnv)
  end
  return newEnv
end

litProgs.buildNewEnv = buildNewEnv

local function renderer(aTemplate, anEnv)
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
            local attrValue = getReference(arguments, anEnv)
            tInsert(result, toStr(attrValue))
          end
        elseif actionType == 'application' then
          if type(arguments) == 'table' and 1 < #arguments then
            local templatePath = tRemove(arguments, 1)
            if type(templatePath) == 'string' then
              templatePath   = parseTemplatePath(templatePath, anEnv)
              local template = navigateToTemplateTable(templatePath)
              local newEnv   = buildNewEnv(template, arguments, anEnv)
              local templateValue = renderer(template, newEnv)
              if type(templateValue) == 'string' then
                tInsert(result, templateValue)
              end
            end
          end
        elseif actionType == 'mapping' then
          if type(arguments) == 'table' and 4 <= #arguments then
            local attrList     = tRemove(arguments, 1)
            local separator    = tRemove(arguments, 1)
            local templatePath = tRemove(arguments, 1)
            local listArg      = tRemove(arguments, 1)
            if type(attrList)     == 'string' and
               type(separator)    == 'string' and
               type(templatePath) == 'string' and
               type(listArg)      == 'string' then
              attrList       = getReference(attrList,  anEnv)
              separator      = getReference(separator, anEnv)
              templatePath   = parseTemplatePath(templatePath, anEnv)
              local template = navigateToTemplateTable(templatePath)
              local newEnv   = buildNewEnv(template, arguments, anEnv )
              if type(separator) ~= 'string' then
                separator = ''
              end
              if type(attrList) ~= 'table' then
                attrList = { attrList }
              end
              if type(attrList) == 'table' and 0 < #attrList then
                for i, anAttrValue in ipairs(attrList) do
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
    return tConcat(result)
  else
    return ""
  end
end

litProgs.renderer = renderer

local function renderCodeFile(aFilePath, codeTable)
  local outFile = io.open(aFilePath, 'w')
  outFile:write(tConcat(codeTable, '\n\n'))
  outFile:close()
end

function litProgs.setCodeStream(aCodeStream)
  code.curCodeStream = aCodeStream
end

function litProgs.addCode(aCodeType, bufferName)
  local bufferContents  =
    buffers.getcontent(bufferName):gsub("\13", "\n")
  code[aCodeType]       = code[aCodeType] or { }
  local codeType        = code[aCodeType]
  local aCodeStream     = code.curCodeStream or 'default'
  codeType[aCodeStream] = codeType[aCodeStream] or { }
  local codeStream      = codeType[aCodeStream]
  tInsert(codeStream, bufferContents)
end

function litProgs.createCodeFile(aCodeType,
                                 aCodeStream,
                                 aFilePath)
  -- here be dragons! -- how do we pass in cType and cSubType
  renderFile(aFilePath, litProgs.templates.lua.file)
  -- here be dragons!
end

function litProgs.addMkIVCode(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  tInsert(code.mkiv, bufferContents)
end

function litProgs.createMkIVFile(aFilePath)
  renderCodeFile(aFilePath, code.mkiv)
end

function litProgs.addLuaCode(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  tInsert(code.lua, bufferContents)
end

function litProgs.createLuaFile(aFilePath)
  renderCodeFile(aFilePath, code.lua)
end

function litProgs.addLuaTemplate(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  tInsert(code.templates, bufferContents)
end

function litProgs.createLuaTemplateFile(aFilePath)
  renderCodeFile(aFilePath, code.templates)
end

function litProgs.addLakefile(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  tInsert(code.lakefile, bufferContents)
end

function litProgs.createLakefile(aFilePath)
  renderCodeFile(aFilePath, code.lakefile)
end