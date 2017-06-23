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
$ ->
  $(document).on 'change', '#result_course_id', (evt) ->
    $.ajax "update_search_topics",
      type: "GET"
      dataType: "script"
      data: {
        course_id: $("#result_course_id option:selected").val()
      }
    $.ajax "update_search_labs",
      type: "GET"
      dataType: "script"
      data: {
        course_id: $("#result_course_id option:selected").val()
      }

      error: (jqXHR, textStatus, errorThrown) ->
        console.log($("#result_course_id option:selected").val())
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic course select OK!")