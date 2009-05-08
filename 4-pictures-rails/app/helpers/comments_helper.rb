module CommentsHelper
  def commentor(comment)
    if comment.person
      comment.person.name
    else
      "Anonymous"
    end
  end
end
