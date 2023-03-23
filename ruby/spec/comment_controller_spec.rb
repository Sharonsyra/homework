require 'dotenv'
require_relative '../app/controllers/comments'

describe CommentController do
  let(:comment_controller) { CommentController.new }

  before(:all) do
    require_relative '../config/environment'
    require_relative '../app/models/db_init' # initializes the database schema; uses ENV credentials
  end

  it 'gets an article\'s comment from db' do
    result = comment_controller.get_comment(1)
    expect(result).to have_key(:ok)
    expect(result).to have_key(:data)
    expect(result[:ok]).to be true
    expect(result[:data]).to be_truthy
    expect(result[:data][:comment]).to eq('First comment 1')
  end

  it 'gets an article\'s comments from db' do
    result = comment_controller.get_article_comments(1)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:data)
    expect(result[:data]).to be_truthy
    expect(result[:data].length).to eq(1)
  end

  it 'adds a test comment to db' do
    comment = {'article_id' => 1, 'comment' => 'Test Comments', 'author_name' => '3 Author', 'created_at' => Time.now }
    result = comment_controller.create_comment(1, comment)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:obj)
    expect(result[:obj]).to be_truthy
  end

  it 'attempts to create the test comment again' do
    comment = {'article_id' => 1, 'comment' => 'Test Comments', 'author_name' => '3 Author', 'created_at' => Time.now }
    result = comment_controller.create_comment(1, comment)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be false
    expect(result).to have_key(:msg)
  end

  it 'updates the test comment in db' do
    comment = { 'comment' => 'Test Comment Updated' }
    result = comment_controller.update_comment(1, comment)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:obj)
    expect(result[:obj]).to be_truthy
    expect(result[:obj].id).to eq(1)
  end

  it 'tries to update a non-existent comment in db' do
    comment = { 'comment' => 'Test Comment Updated' }
    result = comment_controller.update_comment(99, comment)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be false
    expect(result).to have_key (:msg)
  end

  it 'deletes the test comment from db' do
    result = comment_controller.delete_comment(1)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:delete_count)
    expect(result[:delete_count]).to eq(1)
  end

  it 'tries to delete a non-existent comment' do
    result = comment_controller.delete_comment(99)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be false
  end
end
