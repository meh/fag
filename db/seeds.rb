root = User.new(:name => 'root')
root.set_password('password')

root.modes.merge!({
    :admin => true, :can_post_news => true,
    :can_change_modes => true, :can_edit_users => true, :can_delete_users => true, :can_change_user_name => true, :can_see => true,
    :can_edit_flows => true, :can_delete_flows => true, :can_delete_drops => true, 
})

root.save
