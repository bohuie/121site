First_Website::Application.routes.draw do

  get 'course_topics/update'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
devise_for :users, controllers: { registrations: 'users/registrations' }
resource :questions
resource :topics

get 'practices/update_practice_topics', as: 'update_practice_topics'

get 'questions/update_search_topics', as: 'update_search_topics'
get 'questions/update_search_labs', as: 'update_search_labs'
get 'questions/update_question_topics', as: 'update_question_topics'
get 'questions/flag_questions' => 'questions#flag_questions', as: :flag_questions
post 'questions/set_flag_questions' => 'questions#set_flag_questions', as: :set_flag_questions
get 'questions/display_flag_questions' => 'questions#display_flag_questions', as: :display_flag_questions
get 'questions/mark_questions' => 'questions#mark_questions', as: :mark_questions
post 'questions/set_mark_questions' => 'questions#set_mark_questions', as: :set_mark_questions
get 'questions/display_mark_questions' => 'questions#display_mark_questions', as: :display_mark_questions

get 'topics/update_course_topics', as: 'update_course_topics'
post 'course_topics/create' => 'course_topics#create', as: :create_course_topic
delete 'course_topics/delete/:id' => 'course_topics#delete', as: :delete_course_topic
resource :practices

get 'courses/:id/manage' => 'courses#manage', as: :manage_ta
post 'courses/:id/add_ta/:student' => 'courses#add_ta', as: :add_ta
delete 'courses/:id/remove_ta/:student' => 'courses#remove_ta', as: :remove_ta

 
root to: 'static_pages#home'

match '/your_questions', to: 'questions#your_questions', via: 'get'
match '/flag', to: 'questions#flag', via: 'get'
match '/unflag', to: 'questions#unflag', via: 'get'
match '/submitted', to: 'questions#submit', via: 'get'
match '/hidden', to: 'questions#hide', via: 'get'
match '/correct', to: 'questions#correct', via: 'get'
match '/incorrect', to: 'questions#incorrect', via: 'get'
match '/changes', to: 'questions#changes', via: 'get'
match '/comment', to: 'questions#comment', via: 'patch'
match '/remove', to: 'topics#remove', via: 'get'
match '/study/', to: 'practices#use', via: 'get'
match '/answer', to: 'practices#submit', via: 'post'
match '/view', to: 'questions#view', via:'get'
match '/flagview', to: 'questions#flagview', via:'get'
match '/mark', to: 'questions#mark', via:'get'
match '/terms', to: 'static_pages#terms', via:'get'
match '/stats', to: 'static_pages#stats', via:'get'
match '/view', to: 'static_pages#view', via:'post'
match '/flagname', to: 'questions#name', via: 'get'
match '/flagnumber', to: 'questions#number', via: 'get'
match '/flaglab', to: 'questions#lab', via: 'get'
match '/flagtopic', to: 'questions#topic', via: 'get'
match '/flagtime', to: 'questions#time', via: 'get'
match '/flaggrade', to: 'questions#grade', via: 'get'
match '/flagexam', to: 'questions#flagged', via: 'get'
match '/wronganswer', to: 'practices#incorrect', via: 'get'

get 'courses/new' => 'courses#new', as: :new_course
get 'courses/:id' => 'courses#show', as: :show_course
post 'courses' => 'courses#create'

get 'labs/new/:course_id' => 'labs#new', as: :new_lab
get 'lab/:id' => 'labs#show', as: :show_lab
post 'labs' => 'labs#create'

get 'student_labs/new/:course_id' => 'student_labs#new', as: :new_student_lab
post 'student_labs' => 'student_labs#create'

get 'student_courses/new' => 'student_courses#new', as: :new_student_course
post 'student_courses' => 'student_courses#create'

mount Ckeditor::Engine => '/ckeditor'


end