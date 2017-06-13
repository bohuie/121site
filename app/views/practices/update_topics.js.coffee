$("#game_name").empty()
  .append("<option value></option>")
  .append("<%= escape_javascript(render(:partial => @topics)) %>")