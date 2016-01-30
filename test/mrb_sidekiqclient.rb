##
## SidekiqClient Test
##

assert("SidekiqClient#hello") do
  t = SidekiqClient.new "hello"
  assert_equal("hello", t.hello)
end

assert("SidekiqClient#bye") do
  t = SidekiqClient.new "hello"
  assert_equal("hello bye", t.bye)
end

assert("SidekiqClient.hi") do
  assert_equal("hi!!", SidekiqClient.hi)
end
