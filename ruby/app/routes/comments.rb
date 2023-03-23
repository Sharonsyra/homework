require_relative '../controllers/comments'

class CommentRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @commentCtrl = CommentController.new
  end

  before do
    content_type :json
  end

  get('/:article_id/comments') do
    summary = @commentCtrl.get_article_comments(params['article_id'])
    if summary[:ok]
      { comments: summary[:data] }.to_json
    else
      { msg: 'Could not get comments.' }.to_json
    end
  end

  get('/:article_id/comments/:comment_id') do
    comment_with_id = @commentCtrl.get_comment(params['comment_id'])
    if comment_with_id[:ok]
      { comment: comment_with_id[:data] }.to_json
    else
      { msg: "Could not comment with id: #{params['comment_id']}" }.to_json
    end
  end

  post('/:article_id/comments') do
    payload = JSON.parse(request.body.read)
    summary = @commentCtrl.create_comment params['article_id'], payload

    if summary[:ok]
      { msg: 'Comment created' }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end

  put('/:article_id/comments/:comment_id') do
    payload = JSON.parse(request.body.read)
    summary = @commentCtrl.update_comment params['comment_id'], payload

    if summary[:ok]
      { msg: 'Comment updated' }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end

  delete('/:article_id/comments/:comment_id') do
    summary = @commentCtrl.delete_comment params['comment_id']

    if summary[:ok]
      { msg: 'Comment deleted' }.to_json
    else
      { msg: 'Comment does not exist' }.to_json
    end
  end
end
