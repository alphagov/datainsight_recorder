# Data Insight Recorder

This gem extracts some of the commonality between the various recorders in the data insight platform.

# Installation

To make use of it add it to your `Gemfile`

```ruby
gem "datainsight_recorder", "~> 0.0.2"
```

# Data Mapper

There are a few helpers for building models with DataMapper.

For example, to create a time series model that records puppies per week.

```ruby
class PuppiesPerWeek
  # Make this a DataMapper resource
  include DataMapper::Resource

  # Add the base data insight fields
  include DataInsight::Recorder::BaseFields

  # Make this a time series model
  include DataInsight::Recorder::TimeSeries

  # Add our metric variables
  property :puppies, Integer, require: true

  # Validate that time periods are always a week
  validates_with_method :validate_time_series_week
end
```
