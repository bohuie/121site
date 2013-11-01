


namespace :db do
  desc "Fill database with Hardcoded Subject"
  task populate: :environment do
    
    Subject.create!(subject_id: 0, name: 'Agroecology')
    Subject.create!(subject_id: 0, name: 'Anthropology')
    Subject.create!(subject_id: 0, name: 'Applied Science')
    Subject.create!(subject_id: 0, name: 'Arts Co-Op')
    Subject.create!(subject_id: 0, name: 'Art History and Visual Culture')
    Subject.create!(subject_id: 0, name: 'Astronomy')
    Subject.create!(subject_id: 0, name: 'Biochemistry')
    Subject.create!(subject_id: 0, name: 'Biology')
    Subject.create!(subject_id: 0, name: 'Creative abd Critical Studies')
    Subject.create!(subject_id: 0, name: 'Chemistry')
    Subject.create!(subject_id: 0, name: 'Computer Science')
    Subject.create!(subject_id: 0, name: 'Creative Writing')
    Subject.create!(subject_id: 0, name: 'Cultural Studies')
    Subject.create!(subject_id: 0, name: 'Curriculum Studies')
    Subject.create!(subject_id: 0, name: 'Digital Humanities')
    Subject.create!(subject_id: 0, name: 'Educational Administration')
     Subject.create!(subject_id: 0, name: 'Educational Studies')
    Subject.create!(subject_id: 0, name: 'English for Academic Purposes')
    Subject.create!(subject_id: 0, name: 'Early Childhood Education')
    Subject.create!(subject_id: 0, name: 'Economics')
    Subject.create!(subject_id: 0, name: 'Engineering')
    Subject.create!(subject_id: 0, name: 'Environmental Science')
    Subject.create!(subject_id: 0, name: 'Educational Psychology and Special Education')
    Subject.create!(subject_id: 0, name: 'Educational Technology')
    Subject.create!(subject_id: 0, name: 'Exchange Programs')
    Subject.create!(subject_id: 0, name: 'Film')
    Subject.create!(subject_id: 0, name: 'French')
    Subject.create!(subject_id: 0, name: 'Geography')
   	Subject.create!(subject_id: 0, name: 'German')
   	Subject.create!(subject_id: 0, name: 'Gerontology')
   	Subject.create!(subject_id: 0, name: 'Greek')
   	Subject.create!(subject_id: 0, name: 'Gender and Womens Studies')
   	Subject.create!(subject_id: 0, name: 'Health Studies')
   	Subject.create!(subject_id: 0, name: 'Hebrew')
   	Subject.create!(subject_id: 0, name: 'Health-Interprofessional')
   	Subject.create!(subject_id: 0, name: 'History')
   	Subject.create!(subject_id: 0, name: 'Human Kinetics')
   	Subject.create!(subject_id: 0, name: 'Interdisciplinary Graduate Studies')
   	Subject.create!(subject_id: 0, name: 'Indigenous Studies')
   	Subject.create!(subject_id: 0, name: 'Japanese Studies')
   	Subject.create!(subject_id: 0, name: 'Latin')
   	Subject.create!(subject_id: 0, name: 'Language and Literacy Education')
   	Subject.create!(subject_id: 0, name: 'Mathematics')
   	Subject.create!(subject_id: 0, name: 'Management Co-Op')
   	Subject.create!(subject_id: 0, name: 'Management')
   	Subject.create!(subject_id: 0, name: 'Music')
   	Subject.create!(subject_id: 0, name: 'Nursing')
   	Subject.create!(subject_id: 0, name: 'Philosophy')
   	Subject.create!(subject_id: 0, name: 'Physics')
   	Subject.create!(subject_id: 0, name: 'Political Science')
   	Subject.create!(subject_id: 0, name: 'Psychology')
   	Subject.create!(subject_id: 0, name: 'Science Co-Op')
   	Subject.create!(subject_id: 0, name: 'Sociology')
   	Subject.create!(subject_id: 0, name: 'Social Work')
   	Subject.create!(subject_id: 0, name: 'Spanish')
   	Subject.create!(subject_id: 0, name: 'Statistics')
   	Subject.create!(subject_id: 0, name: 'Sustainability')
   	Subject.create!(subject_id: 0, name: 'Theater')
   	Subject.create!(subject_id: 0, name: 'Visiting Graduate Students')
   	Subject.create!(subject_id: 0, name: 'Visual Arts')
   	Subject.create!(subject_id: 0, name: 'Visiting Undergraduate Research Students')


    User.create!(email: 'test@test.com', username: 'test', password: 'testtest', password_confirmation: 'testtest')
  end
end
