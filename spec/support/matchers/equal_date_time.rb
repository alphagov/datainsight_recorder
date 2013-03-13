RSpec::Matchers.define :equal_date_time do |expected|
  match do |actual|
    actual == expected && actual.offset == expected.offset
  end
end
