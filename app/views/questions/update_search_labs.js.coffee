$("#result_lab").empty()
  .append("<option value></option>")
  .append("<%= escape_javascript(render(:partial => @labs)) %>")