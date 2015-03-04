require_relative 'classes'

class Question
  attr_accessor :id, :title, :body, :author

  include SaveObject
  def self.table_name
    @table_name = 'questions'
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = :id
    SQL

    Question.new(result[0])
  end

  def self.find_by_author_id(author_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, :author_id => author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author = :author_id
    SQL

    results.map { |result| Question.new(result) }
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def initialize(question_hash)
    @id, @title, @body, @author = question_hash.values_at('id', 'title', 'body', 'author')
  end

  def author
    User.find_by_id(@author)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    QuestionFollow.followers_for_question_id(id)
  end

  def likers
    QuestionLike.likers_for_question_id(id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end
end
