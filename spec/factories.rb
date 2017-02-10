# Build mock objects for testing purposes here.
# The name of a factory needs to be the same as the model's that it is building.
FactoryGirl.define do

  factory :course do
    name "BA Geography"
  end

  factory :department do
    name "Mathematics"
  end

  factory :tag do
    name "Arbitrary Tag"
    type "CareerTag"
  end

  factory :career_tag do
    name "Software Engineer"
  end

  factory :interest_tag do
    name "Medicine"
  end

  factory :uni_module do
    name "Programming Applications"
    code "4CCS1PRA"
    description "PRA is aimed to further develop the Java programming
    skills of first year students"
    lecturers "Dr. Steffen Zschaler, Dr. Martin Chapman"
  end

  factory :user do
    first_name "Allison"
    last_name "Wonderland"
    email "allison_wonderland@eemail.com"
    username "allisonBurgers"
    password_digest "password"
    user_level 3
    entered_before false
    year_of_study 2
  end
end