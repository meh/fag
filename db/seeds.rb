root = User.new(:name => 'root', :password => 'password')

root.modes.merge!({
    :admin => true, :can_edit => true, :can_see => true, :can_post_news => true
})

root.save
