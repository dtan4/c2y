# C2y

A DSL for [cloud-config.yml](https://coreos.com/docs/cluster-management/setup/cloudinit-cloud-config/)

[![Build Status](https://travis-ci.org/dtan4/c2y.svg?branch=master)](https://travis-ci.org/dtan4/c2y)
[![Code Climate](https://codeclimate.com/github/dtan4/c2y/badges/gpa.svg)](https://codeclimate.com/github/dtan4/c2y)
[![Test Coverage](https://codeclimate.com/github/dtan4/c2y/badges/coverage.svg)](https://codeclimate.com/github/dtan4/c2y)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'c2y'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install c2y

## Usage

TODO: Write usage instructions here

## CloudConfigFile Example

```ruby
update do
  group :beta
  reboot_strategy "best-effort"
end

unit "docker-tcp" do
  command :start
  enable true
  content <<-CONTENT
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=2375
Service=docker.service
BindIPv6Only=both

[Install]
WantedBy=sockets.target
  CONTENT
end

container_unit "nginx" do
  command :start
  enable true
  image "nginx"
  ports %w(80:80)
  environments({
    "SERVER_NAME" => ENV["SERVER_NAME"],
  })
  volumes %w(/home/core/html:/var/www/html)
end

file "/etc/ssh/sshd_config" do
  permissions "0600"
  owner "root:root"
  content <<-CONTENT
# Use most defaults for sshd configuration.
UsePrivilegeSeparation sandbox
Subsystem sftp internal-sftp

PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
  CONTENT
end

user "dtan4" do
  github "dtan4"
  groups %w(sudo docker)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/dtan4/c2y/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
