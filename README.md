# Events

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


# Tables #

## Meeting
 - field :name :string
 - field :date :timestamp
 - belongs_to :user Events.Users.User
 - has_many :comments Events.Comments.Comment
 - has_many :guests Events.Users.User

## Invite
 - field :status :string
 - belongs_to :event Events.Meetings.meeting
 - belongs_to :user Events.User.user

## User
 - field :name :string
 - field :email :string :unique
 - has_many :events Events.Meetings.meeting
 - has_many :comment Events.Comments.comment

## Comment
 - field :body :text
 - field :time :timestamp
 - belongs_to :user Events.Users.User
 - belongs_to :event Events.Meetings.meeting
