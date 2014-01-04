module Schnitzelpress
  # Facade module
  module Facade

    builder = Substation::Environment.build do
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

      register :call, Substation::Processor::Evaluator::Pivot
      register :wrap, Substation::Processor::Wrapper::Outgoing
      register :render, Substation::Processor::Transformer::Outgoing
    end

    INTERNAL_ERROR = builder.chain do
      wrap Error::InternalError
    end

    AUTHENTICATION_ERROR = builder.chain do
      wrap Error::InternalError
    end

    AUTHENTICATE_USER = builder.chain do
      authenticate Handler::Authenticator, AUTHENTICATION_ERROR
    end

    HOME = builder.chain do
      call   Action::Home, INTERNAL_ERROR
      wrap   Presenter::Home
      render View::Template::Home
    end

    VIEW_POST = builder.chain do
      call   Action::ShowPost, INTERNAL_ERROR
      wrap   Presenter::Post
      render View::Template::Post
    end

    ADMIN_HOME = builder.chain(AUTHENTICATE_USER) do
      call   Action::Noop, INTERNAL_ERROR
      render View::AdminTemplate::Home
    end

    define_singleton_method(:dispatcher) do
      builder.dispatcher(Schnitzelpress.env) do
        dispatch :home,       HOME
        dispatch :view_post,  VIEW_POST
        dispatch :admin_home, ADMIN_HOME
      end
    end

  end
end
