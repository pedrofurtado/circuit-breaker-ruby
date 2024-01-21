class CircuitBreaker
  class CircuitIsBlockedError < StandardError
  end

  def initialize(max_tries, wait_timeout)
    close_circuit!
    @max_tries = max_tries
    @wait_timeout = wait_timeout
  end

  def handle(&block)
    if circuit_is_blocked?
      raise CircuitIsBlockedError
    else
      execute(&block)
    end
  end

  private

  def execute(&block)
    result = yield
    close_circuit!
    result
  rescue => e
    @circuit_failures += 1

    if @circuit_failures >= @max_tries
      @circuit_state = :open
      @circuit_opened_at = Time.now
    end

    raise e
  end

  def close_circuit!
    @circuit_state = :closed
    @circuit_opened_at = nil
    @circuit_failures = 0
  end

  def circuit_is_blocked?
    circuit_is_open? && !exceeded_wait_timeout?
  end

  def circuit_is_open?
    @circuit_state == :open
  end

  def exceeded_wait_timeout?
    (@circuit_opened_at + @wait_timeout) < Time.now
  end
end
