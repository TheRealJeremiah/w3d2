class Question
  attr_accessor :id, :title, :body, :author
  def self.find_by_id(id)
    question_result = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = :id
    SQL

    Question.new(question_result[0])
  end

  def initialize(question_hash)
    @id, @title, @body, @author = question_hash.values_at('id', 'title', 'body', 'author')
  end
end
