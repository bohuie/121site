$("#class_topics").empty()
  .append("<%= escape_javascript(render partial: "edit_course_topic_form", local: @course_topic) %>")