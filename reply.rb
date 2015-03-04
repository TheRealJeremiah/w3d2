require_relative 'classes'

class Reply
  attr_accessor :id, :body, :question_id, :user_id, :parent_id

  include SaveObject
  def self.table_name
    @table_name = 'replies'
  end

  def self.find_by_id(id)
    reply_result = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = :id
    SQL

    Reply.new(reply_result[0])
  end

  def self.find_by_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, :user_id => user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = :user_id
    SQL

    results.map { |result| Reply.new(result) }
  end

  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, :question_id => question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = :question_id
    SQL

    results.map { |result| Reply.new(result) }
  end

  def initialize(reply_hash)
    @id, @body, @question_id, @user_id, @parent_id = reply_hash.values_at('id', 'body', 'question_id', 'user_id', 'parent_id')
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    raise "I have no parent" if @parent_id.nil?
    Reply.find_by_id(@parent_id)
  end

  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, :parent_id => @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = :parent_id
    SQL

    results.map { |result| Reply.find_by_id(result['id']) }
  end
end
