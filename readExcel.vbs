' Read an Excel Spreadsheet

Set objExcel = CreateObject("Excel.Application")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Dim objWorkbook
Set objWorkbook = objExcel.Workbooks.Open(objFSO.GetAbsolutePathName(Wscript.Arguments.Item(0)),0,True)

if wscript.arguments.count > 0 then
  for each x in wscript.arguments
    
    strOutFile = replace(x, ".xlsx", ".json")
    set objOutFileJs = objFSO.createtextfile(replace(x, ".xlsx", ".js"))
    set objOutFileJson = objFSO.createtextfile(replace(x, ".xlsx", ".json"))

    objOutFileJs.writeline   "var data=["
    objOutFileJson.writeline "["

    intRow = 3
    Set objWorksheet = objWorkbook.Worksheets(1)
    objWorksheet.Activate
    objWorksheet.UsedRange 'Refresh UsedRange
    LastRow = objWorksheet.UsedRange.Rows(objWorksheet.UsedRange.Rows.Count).Row

    'Root element
    element = " {" _
    & " ""name"" : """ & objExcel.Cells(intRow, 1).Value & """," _
    & " ""parent"" : ""null"" " _
    & "}"

    objOutFileJs.WriteLine element
    objOutFileJson.WriteLine element

    'Nested elements'
    Do Until intRow >= LastRow 
        if objExcel.Cells(intRow,1).Value <> "" then

            objOutFileJs.Write ","
            objOutFileJson.Write ","

            element = "{" _
            & " ""name"" : """       & objExcel.Cells(intRow, 2).Value & """," _
            & " ""parent"" : """     & objExcel.Cells(intRow, 1).Value & """," _
            & " ""dataType"" : """   & objExcel.Cells(intRow, 3).Value & """," _
            & " ""occurrence"" : """ & objExcel.Cells(intRow, 6).Value & """" _
            & "}"

            objOutFileJs.WriteLine element
            objOutFileJson.WriteLine element
        end if

        intRow = intRow + 1
    Loop

    objOutFileJs.writeline "];"
    objOutFileJson.writeline "]"

    objExcel.Quit
  next
  msgbox "Done (" & LastRow & " lines converted)."
else
  msgbox "Drag Excel files over this script for it to work !"
end if