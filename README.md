# Circuit Breaker in Ruby

Very simple Circuit Breaker in Ruby. Just for fun.

## Run demo in localhost

```bash
git clone https://github.com/pedrofurtado/circuit-breaker-ruby.git
cd circuit-breaker-ruby/
docker container run --rm --name circuit-breaker-ruby -v $(pwd):/app -w /app -it ruby:3.3.0-alpine3.18 ruby demo.rb
```
