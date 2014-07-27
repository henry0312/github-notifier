# github-notifier

github-notifier just gets GitHub's Notifications and sends them to OS X's Notification Center.

github-notifier makes up for [GitHub for Mac](https://mac.github.com/) (cf. [GitHub for Mac: Notifications](https://github.com/blog/1287-github-for-mac-notifications)).

![screenshot01](screenshot01.jpg)

![screenshot02](screenshot02.jpg)

## Requirements

* OS X >= 10.8
* Xcode >= 5.0
* ruby >= 2.1
* [octokit.rb](https://github.com/octokit/octokit.rb) (`gem install octokit`)

## Installation

```sh
$ git clone https://github.com/henry0312/github-notifier.git
$ cd github-notifier
$ git submodule init
$ rake build
$ rake conf.rb
Input username: <your github username>
Input password: <your github password> (NOTE: no echo back)
$ rake load
```

If you use [Two-factor Authentication](https://github.com/blog/1614-two-factor-authentication), you have to create `conf.rb` manually.

1. Get an access token from [Authorized applications](https://github.com/settings/applications)  
   NOTE1: The token must have the privilege to access notifications.  
   NOTE2: The privilege to access notifications is only necessary. 
2. Create `conf.rb` as below

```ruby
ACCESS_TOKEN = "<your 40 char token>"
TIME = 5  # minutes
```

## Uninstallation

```sh
$ rake unload
```

## Usage

### Change time interval

If you want to change time interval to get notifications, you need to change `TIME` in `conf.rb` and run:

```sh
$ rake unload
$ rake load
```

### Update

```sh
$ rake update
$ rake build
```

## Contributing

1. Fork it ( https://github.com/henry0312/github-notifier/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Licence

MIT License  
Copyright (c) 2014 Tsukasa ŌMOTO
