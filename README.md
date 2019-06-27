# AggressiveInventory

# Archived

We decided not to move forward with this (unfinished, not-yet-deployed) app since we abandoned microservices and also canceled the (planned, not-yet-started) customer-facing Field Trip app (which might've used some portions/concepts from this app). We reviewed the Golf Cart rental process and recommended tools like Trello to Parking staff (they opted to simply stick with email and a calendar). 

This is UMTS's research spike on gemifying our interaction with the
[Item Reservations API](https://github.com/umts/aggressive-epsilon)

At the moment, this is still a very early build. That being said, we would like
to get it into the hands of our devs to play around with at a very early stage.
So, please pardon our mess during construction.

## Installation

Clone to your local development environment and include into your project.

```ruby
gem 'aggressive_inventory', '0.0.1', path: '/full/path/to/aggressive_inventory'
```

And then execute:

    $ bundle

## Usage
This is designed to be a drop in replacement for our existing `Inventory` code
on the [Rental Application](https://github.com/umts/probable-engine)

```ruby
AggressiveInventory.configure do |config|
  config.base_uri = 'http://localhost:4000/v1/'
  config.auth_token = 'SECRET TOKEN'
end

client = AggressiveInventory::Legacy::Client.new
client.item_types
```

Soon to come... `AggressiveInventory::REST`

## Contributing

1. Fork it ( https://github.com/[my-github-username]/aggressive_inventory/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## CWCID

Much of basic the structure of this this gem is inspired by the very excellent
[Twilio-Ruby](https://github.com/twilio/twilio-ruby) gem. Their work inspires us
to build this project out to a much higher standard.
