class Healthcheck
  OK_RESPONSE = [ 204, {}, [] ]

  def initialize(app)
    @app = app
  end

  def call(env)
    dup._call(env) # thread safe with dup
  end

  def _call(env)
    if env['PATH_INFO'.freeze] == '/healthcheck'.freeze
      return OK_RESPONSE
    else
      @app.call(env)
    end
  end
end
