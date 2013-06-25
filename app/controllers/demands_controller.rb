class DemandsController < ApplicationController
	before_filter :authenticate_user!

	respond_to :json, :xml
	def create
		@failed = ''
		@succeeded = ''
		@message = ''
		@group_id = params[:group_id]
		@user_id = current_user.id
		if(nil_or_empty?(@group_id) or nil_or_empty?(@user_id) or nil_or_empty?(params[:receivers]))
			render :json => { :error => "please provide 'group_id, receivers' parameters." }
		else
			if(group_is_published?(@group_id))
				if(user_is_published?(@user_id))
					if(valid_hash?(params[:receivers]))
						params[:receivers].each do |receiver|
							if(valid_prefix?(receiver.last["prefix"].to_s) and valid_msisdn?(receiver.last["msisdn"].to_s))
								if(demand_creatable?(@group_id, @user, receiver.last["prefix"], receiver.last["msisdn"]))
									@succeeded << receiver.last.to_s << ","
									Demand.create(:group_id => @group_id, :user_id => @user_id, :prefix => receiver.last["prefix"], :msisdn => receiver.last["msisdn"])									
								else
									@message_hash = { "message" => @message }
									@failed << receiver.last.merge(@message_hash).to_s << ","
								end
							else
								@message_hash = { "message" => @message }
								@failed << receiver.last.merge(@message_hash).to_s << ","
							end
						end
						render :json => { :succeeded => @succeeded.chomp(',').sub!("=>", ":").to_s, :failed => @failed.chomp(',').sub!("=>", ":").to_s }
					else
						render :json => { :error => @message }
					end
				else
					render :json => { :error => "this user do not exist or is not published." }
				end
			else
				render :json => { :error => "this group do not exist or is not published." }
			end
		end							
	end	
	
	respond_to :json, :xml
	def show
		if(nil_or_empty?(params[:id]))
			render :json => { :error => "please provide the demand id." }
		else
			if(demand_exists?(params[:id]))
				@demand = @demand
				if((current_user.prefix == @demand.prefix and current_user.msisdn == @demand.msisdn) or current_user.id == @demand.user_id)
					render :template => '/demands/show'
				else				
					render :json => { :error => "that demand do not belong to this user." }
				end
			else
				render :json => { :error => @message }
			end			
		end
	end
	
	respond_to :json, :xml
	def accept
		accept_or_reject(current_user.id, params[:demands_ids], true)		
	end
	
	respond_to :json, :xml
	def reject		
		accept_or_reject(current_user.id, params[:demands_ids], false)
	end
	
	def accept_or_reject(receiver_id, demands_ids, state)
		@failed = {}
		@succeeded = ''
		@message = ''	
		if(nil_or_empty?(receiver_id) or nil_or_empty?(demands_ids))
			render :json => { :error => "please provide 'receiver_id, demands_ids' parameters." }
		else
			if(user_is_published?(receiver_id))
				@receiver = @user
				if(valid_hash?(demands_ids))
					demands_ids.each do |demand_id|
						if(is_not_a_number?(demand_id.first))
							@message_hash = { "#{demand_id.first}" => 'this is not a number.' }
							@failed.merge!(@message_hash)
						else
							if(demand_exists?(demand_id.first))
								if(demand_acceptable?(@demand, receiver_id))
									@succeeded << "#{demand_id.first},"
									@demand.update_attributes(:accepted => state, :decision_date => DateTime.now)
									if(state)
										if(Link.where("user_id = #{@demand.user_id} AND group_id = #{@demand.group_id} AND adherent_id = #{receiver_id}").count == 0)
											Link.create(:user_id => @demand.user_id, :group_id => @demand.group_id, :receive_messages => true, :adherent_id => receiver_id)
										end
									end
								else
									@message_hash = { "#{demand_id.first}" => "#{@message}" }
									@failed.merge!(@message_hash)
								end
							else
								@message_hash = { "#{demand_id.first}" => "#{@message}" }
								@failed.merge!(@message_hash)
							end
						end
					end
					render :json => { :succeeded => @succeeded.chomp(','), :failed => @failed }
				else
					render :json => { :error => "please provide a valid json object." }
				end
			else
				render :json => { :error => "this user do not exist or is not published." }
			end
		end
	end
	
end
