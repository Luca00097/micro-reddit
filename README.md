# README

# Micro-Reddit

A lightweight Reddit-style data layer built with Ruby on Rails. Users submit link posts and other users comment on them. There is no front end: everything is driven and tested from the Rails console, so the focus stays on **data modeling, validations, and Active Record associations**.

## Features

- Users with unique usernames and emails
- Link posts (title + URL) belonging to a user
- Comments belonging to both a user and a post
- Validations at the model level, backed by database constraints
- Cascading deletes so no orphaned posts or comments are left behind

## Tech stack

- Ruby on Rails 7.1+
- SQLite3 (Rails default)
- Active Record (models, migrations, validations, associations)

### Schema

**users**

| Column | Type | Constraints |
|---|---|---|
| id | integer | primary key |
| username | string | not null, unique index |
| email | string | not null, unique index |
| password | string | not null |
| created_at / updated_at | datetime | |

**posts**

| Column | Type | Constraints |
|---|---|---|
| id | integer | primary key |
| title | string | not null |
| url | string | not null |
| user_id | integer | foreign key → users, indexed |
| created_at / updated_at | datetime | |

**comments**

| Column | Type | Constraints |
|---|---|---|
| id | integer | primary key |
| body | text | not null |
| user_id | integer | foreign key → users, indexed |
| post_id | integer | foreign key → posts, indexed |
| created_at / updated_at | datetime | |

## Getting started

```bash
git clone <your-repo-url>
cd micro-reddit
bundle install
rails db:create db:migrate
rails console
```

## Try it in the console

```ruby
# Create users
u1 = User.create!(username: "joshua", email: "joshua@example.com", password: "secret1")
u2 = User.create!(username: "commenter", email: "commenter@example.com", password: "secret2")

# Create a post through the association (user_id is filled in for you)
p1 = u1.posts.create!(title: "Rails Guides", url: "https://guides.rubyonrails.org")

# Comment on it
c1 = Comment.create!(body: "Great link!", user_id: u2.id, post_id: p1.id)

# Walk the associations in both directions
u2.comments.first   # => c1
c1.user             # => u2
p1.comments.first   # => c1
c1.post             # => p1
Post.first.user     # => u1
```

### Seeing validations fail

```ruby
u = User.new
u.valid?                  # => false
u.errors.full_messages    # => readable list of what went wrong

User.new(username: "JOSHUA", email: "x@example.com", password: "secret3").valid?
# => false (usernames are unique regardless of case)

Comment.new(body: "orphan").valid?
# => false (a comment needs a user and a post)
```

Tip: use `create!` while testing. It raises an error with the reason, whereas `create` silently returns an unsaved object when validation fails. After editing a model, run `reload!` in the console.
## Design decisions

- **Foreign key on the "many" side.** `posts.user_id`, `comments.user_id` and `comments.post_id` hold the references; parents never store lists of children.
- **Validations plus database constraints.** `null: false` and unique indexes protect the data even if a validation is bypassed.
- **No password uniqueness.** Rejecting a password because another user has it would leak information. Passwords only need presence and a length rule.
- **Plain-text passwords.** Acceptable for this learning exercise only. A real app should use `has_secure_password` (bcrypt).
- **`dependent: :destroy`.** Deleting a user removes their posts and comments, and deleting a post removes its comments.

## Possible next steps

- Secure passwords with `has_secure_password`
- Add subreddit-style communities (`Community` has_many `posts`)
- Add votes (`Vote` belongs_to `user` and `post`) with a unique pair constraint
- Threaded replies using a nullable `parent_id` on comments
- Add model tests (minitest or RSpec) for every validation and association
- Add controllers and views, or expose a JSON API

## License

Built as a learning project. Use it however you like.
