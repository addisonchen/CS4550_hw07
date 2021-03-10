# Tables #
## Meeting
 - field :name :string
 - field :date :timestamp
 - belongs_to :user Events.Users.User
 - has_many :comments Events.Comments.Comment
 - has_many :guests Events.Users.User

## Invite
 - field :status :string
 - field :email: :string
 - belongs_to :event Events.Meetings.meeting

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

# design decistions #

## user experience
 - No index/show/edit for comments and invites
    - create, delete, and respond to invites and comments from the meething/show.html.eex
  
 - Send the meeting link to guests, not an invite link (no "show" for invites)
    - Guests who go the meeting link will be asked to log in or create an account (clear section on the show meeting page)
  
 - navigation
  - if logged in:
    - view profile, create meeting, and logout buttons on top right of screen
  - if not logged in:
    - login and create account items in top right of screen
  
 - user pages:
  - see a user's meetings and meetings that they are invited to

 - responses:
  - if invited, use the dropdown select form to tell the host if you will be attending
  - if not invited, there will be no dropdown select
  - if you arent logged in, you will be prompted to log in or create an account first
  - backed by plugs on the server

 - default profile picture if the user does not upload one

 - does not handle file too large error


