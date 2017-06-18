$ ->
  $(document).on 'change', '#question_course_created_in', (evt) ->
    $.ajax "update_question_topics",
      type: "GET"
      dataType: "script"
      data: {
        course_id: $("#question_course_created_in option:selected").val()
      }

      error: (jqXHR, textStatus, errorThrown) ->
        console.log($("#question_course_created_in option:selected").val())
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic course select OK!")