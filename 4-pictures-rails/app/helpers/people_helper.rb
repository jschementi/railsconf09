module PeopleHelper
  
  def picture_index_title
    if @person
      if @person == current_person
        "Your Pictures"
      else
        "#{@person.name}#{@person.name[-1, 1] == "s" ? "'" : "'s"} Pictures"
      end
    else
      nil
    end
  end
  
end
