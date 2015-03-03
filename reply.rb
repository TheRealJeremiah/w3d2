class Reply
  attr_accessor :id, :body, :question_id, :user_id, :parent_id
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

  def initialize(reply_hash)
    @id, @body, @question_id, @user_id, @parent_id = reply_hash.values_at('id', 'body', 'question_id', 'user_id', 'parent_id')
  end
end
