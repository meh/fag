root = User.new(:name => 'root')
root.set_password('password')

root.modes.merge!({
    :admin => true, :can_see => true,
    :can_change_modes => true, :can_edit_users => true, :can_delete_users => true, :can_change_user_name => true, :can_change_user_password => true,
    :can_create_tags => true, :can_edit_tags => true,
    :can_edit_codes => true, :can_delete_codes => true,
    :can_create_projects => true, :can_edit_projects => true, :can_delete_projects => true,
    :can_edit_flows => true, :can_delete_flows => true, :can_stop_flows => true, :can_restart_flows => true, :can_delete_drops => true,

    :priority_cap => -23,
})

root.save
