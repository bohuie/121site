$("#question_topic_id").empty()
  .append("<option value></option>")
  .append("<%= escape_javascript(render(:partial => @topics)) %>")