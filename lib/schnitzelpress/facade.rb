module Schnitzelpress
  # Facade module
  module Facade

    builder = Substation::Environment.build do
      register :call, Substation::Processor::Evaluator::Pivot
      register :wrap, Substation::Processor::Wrapper::Outgoing
      register :render, Substation::Processor::Transformer::Outgoing
    end

    INTERNAL_ERROR = builder.chain do
      wrap Schnitzelpress::Error::InternalError
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

    define_singleton_method(:dispatcher) do
      builder.dispatcher(Schnitzelpress.env) do
        dispatch :home,      HOME
        dispatch :view_post, VIEW_POST
      end
    end

  end
end
