# disable log buffering
$stdout.sync = true

require 'logger'
$logger = Logger.new($stdout)

class Echo
  require 'json'

  def call(env)
    headers = env.keys.inject({}) { |h, k|
      # all request headers are prefixed with HTTP_
      h[k.sub(/^HTTP_/, '')] = env[k] if k.start_with? 'HTTP_'
      h
    }

    body = env['rack.input'].read

    $logger.info "Headers: #{headers}"
    $logger.info "Body: #{body}"

    [200, header(headers), body({ msg: 'echo' })]
  end

  def header(headers)
    {
      'Content-Type' => 'application/json',
      'Access-Control-Allow-Origin' => headers['ORIGIN'] || 'null',
      'Access-Control-Allow-Headers' => headers['ACCESS_CONTROL_REQUEST_HEADERS'] || 'null',
      'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, PATCH'
    }
  end

  def body(data)
    [data.to_json]
  end
end

run Echo.new

require 'debugger'
