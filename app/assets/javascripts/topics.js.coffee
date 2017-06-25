$ ->
  $(document).on 'change', '#topic_course_id', (evt) ->
    $.ajax "topics/update_course_topics",
      type: "GET"
      dataType: "script"
      data: {
        course_id: $("#topic_course_id option:selected").val()
      }

      error: (jqXHR, textStatus, errorThrown) ->
        console.log($("#topic_course_id option:selected").val())
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic course select OK!")