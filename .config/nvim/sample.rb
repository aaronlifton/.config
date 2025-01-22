# frozen_string_literal: true

class A
  class B
    belongs_to :category, dependent: :destroy

    def foo
      bar(1)
    end

    def self.bar
      foo(1,2)
    end
  end
end
