def newCOM progId
  System::Activator.CreateInstance(System::Type.GetTypeFromProgID(progId))
end

ex = newCOM("Excel.Application")

ex.Visible = true
nb = ex.Workbooks.Add
ws = nb.Worksheets[1]
p ws.Name

10.times do |i|
  10.times do |j|
    ws.Cells[i + 1, j + 1] = (i + 1) * (j + 1)
  end
end
