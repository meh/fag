fag (Forums Are Gay) - A board for coders.
==========================================

Written with Grape.

Models design
-------------

```
Flow -> id
     -> tags
     -> author
     -> anonymous?
     -> title
     -> drops

Drop -> flow
     -> author
     -> anonymous?
     -> title
     -> message

Float -> id
      -> author
      -> anonymous?
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

Version 1 (this means you have to prepend /1 to every request):

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

```
