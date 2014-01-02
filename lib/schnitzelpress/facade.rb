module Schnitzelpress
  # Facade module
  module Facade

    builder = Substation::Environment.build do
      register :call, Substation::Processor::Evaluator::Pivot
      register :wrap, Substation::Processor::Wrapper::Outgoing
      register :render, Substation::Processor::Transformer::Outgoing
    end

    INTERNAL_ERROR = builder.chain { wrap Schnitzelpress::Error::InternalError }

    HOME = builder.chain do
      call Action::Home, INTERNAL_ERROR
      wrap Presenter::Home
      render View::Template::Home
    end

    define_singleton_method(:dispatcher) do
      builder.dispatcher(Schnitzelpress.env) do
        dispatch :home, HOME
      end
    end

  end
end
