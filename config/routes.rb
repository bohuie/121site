First_Website::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
devise_for :users
resource :questions
resource :search, :controller => :search
resource :topics
resource :practices

 
root to: 'static_pages#home'

match '/your_questions', to: 'questions#your_questions', via: 'get'
match '/flag_questions', to: 'questions#flag_questions', via: 'get'
match '/find_questions', to: 'search#find_questions', via: 'get'
match '/flag', to: 'questions#flag', via: 'get'
match '/unflag', to: 'questions#unflag', via: 'get'
match '/submitted', to: 'questions#submit', via: 'get'
match '/hidden', to: 'questions#hide', via: 'get'
match '/correct', to: 'questions#correct', via: 'get'
match '/incorrect', to: 'questions#incorrect', via: 'get'
match '/changes', to: 'questions#changes', via: 'get'
match '/comment', to: 'questions#comment', via: 'patch'
match '/search', to: 'search#create', via: 'get'
match '/remove', to: 'topics#remove', via: 'get'
match '/study/', to: 'practices#use', via: 'get'
match '/answer', to: 'practices#submit', via: 'post'
match '/view', to: 'questions#view', via:'get'
match '/flagview', to: 'questions#flagview', via:'get'
match '/mark', to: 'questions#mark', via:'get'
match '/terms', to: 'static_pages#terms', via:'get'
match '/stats', to: 'static_pages#stats', via:'get'
match '/view', to: 'static_pages#view', via:'post'
match '/name', to: 'search#name', via: 'get'
match '/name', to: 'search#name', via: 'get'
match '/number', to: 'search#number', via: 'get'
match '/lab', to: 'search#lab', via: 'get'
match '/topic', to: 'search#topic', via: 'get'
match '/time', to: 'search#time', via: 'get'
match '/grade', to: 'search#grade', via: 'get'
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

get 'student_labs/new/:lab_id', as: :new_student_lab
post 'student_labs/create'

mount Ckeditor::Engine => '/ckeditor'


end