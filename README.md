fag (Forums Are Gay) - A board for coders.
==========================================

Written with Grape.

Models design
-------------

```
Flow -> id
     -> title
     -> tags
     -> author_name # present if Anonymous
     -> author_id   # present if logged in User
     -> drops

Drop -> id
     -> title
     -> author_name # present if Anonymous
     -> author_id   # present if logged in User
     -> message

Float -> id
      -> author_name # present if Anonymous
      -> author_id   # present if logged in User
      -> name
      -> language
      -> content

User -> id
     -> name
     -> email (not required)
     -> flows
     -> drops
```

API design
----------

Version 1 (this means you have to prepend `/1/` to every request):

```
# this returns the csrf token, every request that's not a GET needs to
# have passed this token as a _csrf parameter otherwise the request will
# fail with a 403
GET /csrf

# this request is used to get a new csrf token, usually not needed
GET /csrf/renew

# this returns true or false wether you're logged in or not
GET /auth

# this is the entry point, once authorized you get back a cookie
POST /auth # id: the id or the name of the user
           # password: the password to login

# all multiple fetching can have passed a limit and/or offset option, this way you can
# fetch only the group of messages you want

# flows are sorted by creation date in descending order
# drops are sorted by creation date in ascending order

GET /flows # expression: the boolean tag expression to look for

GET /flows/:id # get the whole flow

PUT /flows/:id # tags (optional): json encoded array of tags to replace with
               # title (optional): the new title
               # author_name (optional): set the flow author as anonymous with the given name
               # author_id (optional): set the flow author as the registered user with the given id

DELETE /flows/:id # delete the flow

GET /flows/:id/drops # get the drops for the given flow

POST /flows/:id/drops # name (optional if not logged in): name to set as anonymous author
                      # title (optional): the title for the drop
                      # content: the content of the drop

GET /drops/:id # get the given drop

PUT /drops/:id # title (optional): the new title for the drop
               # author_name (optional): set the drop author as anonymous with the given name
               # author_id (optional): set the drop author as the registered user with the given id
               # content (optional): set the new content

DELETE /drops/:id # destroy the given drop
```
