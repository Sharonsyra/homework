class CommentController
  def create_comment(article_id, comment)
    comment_not_exists = (Comment.where(:comment => comment['comment']).empty?)

    return { ok: false, msg: 'Comment already exists' } unless comment_not_exists

    new_comment = Comment.new(:article_id => article_id, :comment => comment["comment"], :author_name => comment["author_name"], :created_at => Time.now)
    new_comment.save

    { ok: true , obj: new_comment }
  rescue StandardError
    { ok: false }
  end

  def update_comment(comment_id, new_data)

    comment = Comment.where(id: comment_id).first

    return { ok: false, msg: 'Comment could not be found' } unless comment.present?
    comment.comment = new_data['comment']
    comment.save

    { ok: true, obj: comment }
  rescue StandardError
    { ok: false }
  end

  def get_comment(comment_id)
    res = Comment.where(:id => comment_id)

    if res.empty?
      { ok: false, msg: 'Comment not found' }
    else
      { ok: true,  data: res.first }
    end
  rescue StandardError
    { ok: false }
  end

  def delete_comment(comment_id)
    delete_count = Comment.delete(comment_id)

    if delete_count == 0
      { ok: false }
    else
      { ok: true, delete_count: delete_count }
    end
  end

  def get_article_comments(article_id)
    article_comments = Comment.where(article_id: article_id)

    if article_comments.nil?
      { ok: false, msg: 'Article has no comments' }
    else
      { ok: true, data: article_comments }
    end
  end
end
