DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;

CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  author INTEGER REFERENCES users(id)
);

CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id),
  user_id INTEGER REFERENCES users(id)
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  body TEXT,
  question_id INTEGER NOT NULL REFERENCES questions(id),
  user_id INTEGER REFERENCES users(id),
  parent_id INTEGER REFERENCES replies(id)
);

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id),
  user_id INTEGER REFERENCES users(id)
);

INSERT INTO
  users
  (fname, lname)
VALUES
  ('CJ', 'Avilla'), ('Ned', 'Rugerri');

INSERT INTO
  questions
  (title, body, author)
VALUES
  ('How to Program', 'How do I do it???', 1), ('Do you lie to bananas?', 'I really want to know!', 2);

INSERT INTO
  question_follows
  (question_id, user_id)
VALUES
  (2, 1);

INSERT INTO
  replies
  (body, question_id, user_id, parent_id)
VALUES
  ('why?', 1, 2, NULL),
  ('because', 1, 1, 1),
  ('i teach you', 1, 2, 2);

INSERT INTO
  question_likes
  (user_id, question_id)
VALUES
  (1, 2);
