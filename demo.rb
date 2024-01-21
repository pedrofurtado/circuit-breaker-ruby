require_relative 'circuit_breaker'

max_tries = 3
wait_timeout = 5
circuit_breaker = CircuitBreaker.new(max_tries, wait_timeout)

def call_failure_in_circuit_breaker(circuit_breaker)
  begin
    circuit_breaker.handle do
      raise "oh, something goes wrong!"
    end
  rescue => e
    puts "failure: #{e.message} [#{Time.now}]"
  end
end

def call_success_in_circuit_breaker(circuit_breaker)
  begin
    circuit_breaker.handle do
      puts "success: everything ok! [#{Time.now}]"
    end
  rescue => e
    puts "failure: #{e.message} [#{Time.now}]"
  end
end

100.times do
  if [true, false].sample
    call_success_in_circuit_breaker(circuit_breaker)
  else
    call_failure_in_circuit_breaker(circuit_breaker)
  end

  sleep(1)
end
