User.create(:name => 'root', :password => 'password', :modes => {
        :admin => true, :can_edit => true, :can_see => true, :can_post_news => true
}.to_yaml)
