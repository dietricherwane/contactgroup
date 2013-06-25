object @demand

# Declare the properties to include
attributes :id, :user_id, :group_id, :accepted, :decision_date, :created_at

# returns prefix and msisdn if the user is not registered and its id if it is 
@receiver = User.where("prefix = '#{@demand.prefix}' AND msisdn = '#{@demand.msisdn}'")
if(@receiver.empty?)
	attributes :prefix, :msisdn
else
	node :receiver_id do |receiver_id|
		User.where("prefix = '#{@demand.prefix}' AND msisdn = '#{@demand.msisdn}'").first.id
	end
end
