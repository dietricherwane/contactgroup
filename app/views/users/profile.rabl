object @user

# Include a custom node with full_name for user
node :full_name do |user|
  [user.firstname, user.lastname].join(" ")
end
 
# Declare the properties to include
attributes :email, :birthdate, :authentication_token, :gender, :msisdn, :prefix, :published, :created_at
 
# Alias 'age' to 'years_old'
#attributes :age => :years_old
  
# Include a custom node related to if the user can drink
#node :can_drink do |user|
  #user.age >= 21
#end
