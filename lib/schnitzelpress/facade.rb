module Schnitzelpress
  # Facade module
  module Facade
    ENV = Substation::Environment.build(Schnitzelpress.env) do
      register(
        :deserialize,
        Substation::Processor::Transformer::Incoming,
        Deserializer::EXECUTOR
      )

      register(
        :authenticate,
        Substation::Processor::Evaluator::Request,
        Authenticator::EXECUTOR
      )

      register :call,   Substation::Processor::Evaluator::Pivot
      register :wrap,   Substation::Processor::Wrapper::Outgoing
      register :render, Substation::Processor::Transformer::Outgoing
    end

    INTERNAL_ERROR = ENV.chain do
      wrap Error::InternalError
    end

    AUTHENTICATION_ERROR = ENV.chain do
      wrap Error::InternalError
    end

    AUTHENTICATE_USER = ENV.chain do
      authenticate Handler::Authenticator, AUTHENTICATION_ERROR
    end

    ENV.register(:home) do
      call   Action::Home, INTERNAL_ERROR
      wrap   Presenter::Home
      render View::Template::Home
    end

    ENV.register(:view_post) do
      call   Action::ShowPost, INTERNAL_ERROR
      wrap   Presenter::Post
      render View::Template::Post
    end

    ENV.register(:login_form) do
      call   Action::Noop
      render View::Template::Login
    end

    ENV.register(:admin_home, AUTHENTICATE_USER) do
      call   Action::Noop, INTERNAL_ERROR
      render View::AdminTemplate::Home
    end
  end
end
