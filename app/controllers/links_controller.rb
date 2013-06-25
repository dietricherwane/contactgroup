class LinksController < ApplicationController
	before_filter :authenticate_user!

	respond_to :json, :xml
	def enable_message_reception
		message_reception(current_user.id, params[:groups_ids], true)
	end
	
	respond_to :json, :xml
	def disable_message_reception
		message_reception(current_user.id, params[:groups_ids], false)
	end
	
	def message_reception(adherent_id, groups_ids, status)
		@failed = {}
		@succeeded = ''
		@message = ''
		if(nil_or_empty?(adherent_id) or nil_or_empty?(groups_ids))
			render :json => { :error => "please provide 'adherent_id, groups_ids' parameters." }
		else
			if(user_is_published?(adherent_id))
				if(valid_hash?(groups_ids))
					groups_ids.each do |group_id|
						if(is_not_a_number?(group_id.first))
							@message_hash = { "#{group_id.first}" => 'this is not a number.' }
							@failed.merge!(@message_hash)
						else
							if(group_is_published?(group_id.first))
								@link = @group.links.where("deleted IS NOT TRUE AND adherent_id = #{current_user.id}")
								if(@link.empty?)
									@message_hash = { "#{group_id.first}" => 'this link do no exist or has been deleted.' }
									@failed.merge!(@message_hash)
								else
									@succeeded << "#{group_id.first},"
									@link.first.update_attributes(:receive_messages => status)
									LinkLog.create(:receive_message => status, :link_id => @link.first.id)
								end
							else
								@message_hash = { "#{group_id.first}" => @message }
								@failed.merge!(@message_hash)
							end
						end						
					end
					render :json => { :succeeded => @succeeded.chomp(','), :failed => @failed }
				else
					render :json => { :error => @message }
				end
			else
				render :json => { :error => @message }
			end
		end
	end

end
